require 'capybara'
require 'capybara/dsl'
require 'RMagick'
require "sniper"

Capybara.default_driver = :selenium
Capybara.app_host = 'http://www.google.com'

