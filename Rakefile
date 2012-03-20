require 'bundler/gem_tasks'
require 'rspec/core'
require 'rspec/core/rake_task'
require File.expand_path('spec/spec_helper.rb')


task :default => :full_build

desc "full build, run all the tests"
task :full_build => [:unit, :acceptance]

desc "Run unit tests"
RSpec::Core::RakeTask.new(:unit) do |t|
  t.pattern = ['spec/*_spec.rb']
  t.rspec_opts = ['--options', "spec/spec.opts"]
end


desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance) do |t|
  t.pattern = ['spec/acceptance/*_spec.rb']
  t.rspec_opts = ['--options', "spec/spec.opts"]
end
