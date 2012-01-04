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


Capybara.app = Sinatra::Application
Capybara.default_driver = :selenium




set :run, true
set :environment, :test



#todo: spec folders clean up method


