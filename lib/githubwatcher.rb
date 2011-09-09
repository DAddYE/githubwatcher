require 'yaml' unless defined?(YAML)
require "githubwatcher/version"
require "httparty"
require "growl"

YAML::ENGINE.yamler = "syck" if defined?(YAML::ENGINE)

module Githubwatcher
  extend self
  include HTTParty

  API   = File.expand_path("~/.githubwatcher/api.yaml")
  WATCH = File.expand_path("~/.githubwatcher/repos.yaml")
  DB    = File.expand_path("~/.githubwatcher/db.yaml")

  format :json

  def setup
    raise "You need to install growlnotify, use brew install growlnotify or install it from growl.info site" unless Growl.installed?
    puts "Starting GitHub Watcher..."

    unless File.exist?(API)
      Dir.mkdir(File.dirname(API)) unless File.exist?(File.dirname(WATCH))
      File.open(API, "w") { |f| f.write ["https://api.github.com", "v3"].to_yaml }
    end

    unless File.exist?(WATCH)
      warn "Add the repositories you're willing to monitor editing: ~/.githubwatcher/repos.yaml"
      Dir.mkdir(File.dirname(WATCH)) unless File.exist?(File.dirname(WATCH))
      File.open(WATCH, "w") { |f| f.write ["daddye/all", "padrino/all"].to_yaml }
    end

    @_watch = YAML.load_file(WATCH)
    @_repos = YAML.load_file(DB) if File.exist?(DB)
    @base_uri, @api_version = YAML.load_file(API)

    base_uri @base_uri
  end

  def start!
    repos_was = repos.dup
    watch.each do |value|
      key, value = *value.split("/")
      r = get_repositories(key)
      r.each do |repo|
        next unless value.include?(repo["name"]) || value.include?("all")
        puts "Quering #{repo["git_url"]}..."

        found = repos_was.find { |r| r["name"] == repo["name"] }

        repo_fullname = [repo['owner']['login'],repo['name']].join('/')
        if !found
          notify(repo_fullname, "Was created")
          repos_was << repo
          repos << repo
        end

        repo_was = repos_was.find { |r| r["name"] == repo["name"] }

        if repo_was["watchers"] != repo["watchers"]
          notify(repo_fullname, "Has new #{repo["watchers"]-repo_was["watchers"]} watchers")
          repo_was["watchers"] = repo["watchers"]
        end

        if repo_was["open_issues"] != repo["open_issues"]
          notify(repo_fullname, "Has new #{repo["open_issues"]-repo_was["open_issues"]} open issues")
          repo_was["open_issues"] = repo["open_issues"]
        end

        if repo_was["pushed_at"] != repo["pushed_at"]
          notify(repo_fullname, "Was updated!")
          repo_was["pushed_at"] = repo["pushed_at"]
        end

        if repo_was["forks"] != repo["forks"]
          notify(repo_fullname, "Has new #{repo["forks"]-repo_was["forks"]} forks")
          repo_was["forks"] = repo["forks"]
        end

        found = repo if found
      end
    end
    Dir.mkdir(File.dirname(DB)) unless File.exist?(File.dirname(DB))
    File.open(DB, "w"){ |f| f.write @_repos.to_yaml }
  end
  alias :run :start!

  def repos
    @_repos ||= []
  end

  def watch
    @_watch ||= []
  end

  def notify(title, text, sticky=true)
    Growl.notify(text, :title => title, :icon => File.expand_path("../../images/icon.png", __FILE__), :sticky => sticky); sleep 0.2
    puts "=> #{title}: #{text}"
  end

  def get_repositories(key)
    r = get resource_url(key)
    @api_version == "v3" ? r : r["repositories"]
  end

  def resource_url(key)
    case @api_version
      when "v3"
        "/users/%s/repos" % key
      when "v2"
        "/api/v2/json/repos/show/%s" % key
      else
        raise "Unkown api version"
    end
  end
end
