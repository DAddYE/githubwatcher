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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.add_dependency 'httparty', '~>0.7.8'
  s.add_dependency 'growl',    '~>1.0.3'
  s.add_dependency 'foreverb', '~>0.1.6'
  s.add_dependency 'mail',     '~>2.3.0'
end