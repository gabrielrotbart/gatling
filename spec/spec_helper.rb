require  File.join(File.dirname(__FILE__), '/support/assets/smiley_app')

require 'rubygems'
require 'sinatra'
Sinatra::Application.environment = :test
require 'rack/test'
# require 'spec'
# require 'spec/autorun'
# require 'spec/interop/test'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'gatling'
require 'gatling/matchers/look_like_matcher'
require 'fileutils'


Capybara.app = Sinatra::Application
Capybara.default_driver = :selenium

set :run, true
set :environment, :test

def remove_refs(dir)
 FileUtils.rm_rf dir.to_s 
end

def gatling_for_spec(expected)
  visit('/')
  @element = page.find(:css, "#smiley")
  
  @gatling = Gatling::Comparison.new(expected, @element)
end

def spec_support_root
   File.join(File.dirname(__FILE__), 'support')
end
  

#todo: spec folders clean up method


