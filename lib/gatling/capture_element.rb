require 'fileutils'
require 'gatling/config'

module Gatling
  module CaptureElement
    extend Gatling::Configuration

    def self.capture(element)
      # Getting the element position before screenshot because of a side effect
      # of WebDrivers getLocationOnceScrolledIntoView method which scrolls the page
      # regardless of whether the object is in view or not
      element_position = get_element_position(element)
      screenshot = take_screenshot

      crop_element(screenshot, element, element_position)
    end

    private
    def self.take_screenshot
      temp_dir = Gatling::Configuration.path(:temp)
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

    def self.get_element_position element
      element = element.native
      position = Hash.new{}
      position[:x] = element.location.x
      position[:y] = element.location.y
      position[:width] = element.size.width
      position[:height] = element.size.height
      position
    end

    def self.crop_element image, element_to_crop, position
      cropped_element = image.crop(position[:x], position[:y], position[:width], position[:height])
    end

  end
end

