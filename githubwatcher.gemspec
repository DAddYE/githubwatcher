# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "githubwatcher/version"

Gem::Specification.new do |s|
  s.name        = "githubwatcher"
  s.version     = Githubwatcher::VERSION
  s.authors     = ["Davide D'Agostino"]
  s.email       = ["d.dagostino@lipsiasoft.com"]
  s.homepage    = "https://github.com/DAddYE/githubwatcher"
  s.summary     = "Github Growl Watcher, watch any project and receive growl notification"
  s.description = "Github Growl Watcher, watch any project and receive growl notification for updates, new watchers, forks and issues"

  s.rubyforge_project = "githubwatcher"

  s.files         = Dir["**/*"].reject { |f| File.directory?(f) || f == "Gemfile.lock" }
  s.test_files    = []
  s.executables   = %w[githubwatcher]
  s.require_paths = %w[lib]
  s.add_dependency 'httparty', '~>0.7.8'
  s.add_dependency 'growl',    '~>1.0.3'
  s.add_dependency 'foreverb', '~>0.3.0'
end
