require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task' 
require File.expand_path('spec/spec_helper.rb')

task :default => ["run"]

desc "default test run"
RSpec::Core::RakeTask.new(:run) do |t|
  t.pattern = ['spec/*_spec.rb']
  t.rspec_opts = ['--options', "spec/spec.opts"]
end
  