require 'yaml' unless defined?(YAML)
require "githubwatcher/version"
require "httparty"
require "growl"

YAML::ENGINE.yamler = "syck" if defined?(YAML::ENGINE)

module Githubwatcher
  extend self
  include HTTParty

  WATCH = File.expand_path("~/.githubwatcher/repos.yaml")
  DB    = File.expand_path("~/.githubwatcher/db.yaml")

  base_uri 'https://api.github.com'
  format :json

  def setup
    raise "You need to install growlnotify, use brew install growlnotify or install it from growl.info site" unless Growl.installed?
    puts "Starting GitHub Watcher..."

    unless File.exist?(WATCH)
      warn "Add the repositories you're willing to monitor editing: ~/.githubwatcher/repos.yaml"
      Dir.mkdir(File.dirname(WATCH)) unless File.exist?(File.dirname(WATCH))
      File.open(WATCH, "w") { |f| f.write ["daddye/all", "padrino/all"].to_yaml }
    end

    @_watch = YAML.load_file(WATCH)
    @_repos = YAML.load_file(DB) if File.exist?(DB)
  end

  def start!
    repos_was = repos.dup
    watch.each do |value|
      key, value = *value.split("/")
      r = get "/users/%s/repos" % key
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

  def notify(title, text)
    Growl.notify text, :title => title, :icon => File.expand_path("../../images/icon.png", __FILE__); sleep 0.2
    puts "=> #{title}: #{text}"
  end
end