require 'fileutils'

module Gatling
  class CaptureElement

    def initialize element_to_capture, *element_to_exclude
      @reference_image_path = Gatling::Configuration.reference_image_path
      @element_to_capture = element_to_capture
      # @element_to_exclude = element_to_exclude.first

    end

    def capture
      # Getting the element position before screenshot because of a side effect
      # of WebDrivers getLocationOnceScrolledIntoView method which scrolls the page
      # regardless of whether the object is in view or not
      element_position = get_element_position @element_to_capture
      screenshot = self.take_screenshot
      screenshot = exclude(screenshot, @element_to_exclude) if @element_to_exclude
      crop_element(screenshot, @element_to_capture, element_position)
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

    def get_element_position element
      element = element.native
      position = Hash.new{}
      position[:x] = element.location.x
      position[:y] = element.location.y
      position[:width] = element.size.width
      position[:height] = element.size.height
      position
    end

    def crop_element image, element_to_crop, position
      @cropped_element = image.crop(position[:x], position[:y], position[:width], position[:height])
    end

  end
end

