require 'capybara'
require 'capybara/dsl'
require 'gatling'
require 'matchers/look_like_matcher.rb'

Capybara.default_driver = :selenium
Capybara.app_host = 'http://www.google.com'


