require 'rubygems'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'gatling'
require 'gatling/matchers/look_like_matcher'
require 'fileutils'
require 'pry'

#todo: spec folders clean up method

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end

Capybara.app_host = "file://#{File.expand_path(File.dirname(__FILE__))}/support/assets"
Capybara.default_driver = :selenium
Capybara.run_server = false

def remove_refs(dir)
  FileUtils.rm_rf dir.to_s
end

def element_for_spec(css = '#black')
  visit('/fruit_app.html')
  @element = page.find(:css, css)
end

def spec_support_root
  File.join(File.dirname(__FILE__), 'support')
end

def create_images_for_web_page
  asset_path = File.join(spec_support_root, 'assets')
  create_square_image(asset_path, 'black')
  create_square_image(asset_path, 'red')
end

def create_square_image(path, color)
  FileUtils::mkdir_p(path)

  reference_file = Magick::Image.new(100,100) { self.background_color = 'white' }
  square = Magick::Draw.new
  square.fill_opacity(100)
  square.fill_color(color)
  square.rectangle(10,10, 90,90)
  square.draw(reference_file)

  reference_file.write(File.join(path, "#{color}.png"))
  reference_file
end
