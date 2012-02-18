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

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

Capybara.app = Sinatra::Application
Capybara.default_driver = :selenium

set :run, false
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

def save_element_for_test
  Gatling::Configuration.trainer_toggle = true
  gatling_for_spec('smiley-faceicon.png').matches?
  Gatling::Configuration.trainer_toggle = false
end

def convert_element_to_bad_element(image_file)
  #convert -fill none -stroke black -strokewidth 5 smiley-faceicon.png -draw 'arc 155,25 185,45 180' sad-faceicon.png
  image = Magick::Image.read(image_file).first
  frown = Magick::Draw.new
  frown.stroke('black')
  frown.stroke_width(5)
  frown.fill_opacity(0)
  frown.stroke_opacity(10)
  frown.arc(155,25,185,45,180,0)
  frown.draw(image)
  bad_element = image.write(image_file)
end

#todo: spec folders clean up method


