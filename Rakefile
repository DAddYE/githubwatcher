require 'rubygems' unless defined?(Gem)
require 'bundler/gem_tasks'

%w(install release).each do |task|
  Rake::Task[task].enhance do
    sh "rm -rf pkg"
  end
end

desc "Bump version on github"
task :bump do
  puts "Nothing to commit (working directory clean)" and return if `git status -s`.strip == ""
  if `git status -s`.strip == ""
    puts "\e[31mNothing to commit (working directory clean)\e[0m"
  else
    version = Bundler.load_gemspec(Dir[File.expand_path('../*.gemspec', __FILE__)].first).version
    sh "git add .; git commit -a -m \"Bump to version #{version}\""
  end
end

task :release => :bump
