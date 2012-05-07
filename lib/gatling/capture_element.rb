require 'fileutils'
require_relative 'image_wrangler'

module Gatling
  class CaptureElement

  include ImageWrangler

    def initialize element_to_capture, *element_to_exclude
      @reference_image_path = Gatling::Configuration.reference_image_path
      @element_to_capture = element_to_capture
      # @element_to_exclude = element_to_exclude.first

    end

    def capture
      screenshot = self.take_screenshot
      screenshot = exclude(screenshot, @element_to_exclude) if @element_to_exclude
      Gatling::ImageWrangler.crop_element(screenshot, @element_to_capture)
    end

    def take_screenshot
      temp_dir = File.join(@reference_image_path, 'temp')
      FileUtils.mkdir_p(temp_dir) unless File.exists?(temp_dir)
      #captures the uncropped full screen
      begin
        temp_screenshot_filename = File.join(temp_dir, "temp-#{Process.pid}.png")
        Capybara.page.driver.browser.save_screenshot(temp_screenshot_filename)
        temp_screenshot = Magick::Image.read(temp_screenshot_filename).first
      rescue
        raise "Could not save screenshot to #{temp_dir}. Please make sure you have permission"
      end
    end
  end
end

