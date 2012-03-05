require_relative 'image_wrangler'

module Gatling
  class CaptureElement

    def initialize element_to_capture, *element_to_exclude
      @reference_image_path = Gatling::Configuration.reference_image_path
      @element_to_capture = element_to_capture
      @element_to_exclude = element_to_exclude.first
      @expected_image = "#{@reference_image_path}/#{@expected}"
      @expected_filename = "#{@expected}".sub(/\.[a-z]*/,'')
    end

    def into_image
      screenshot = self.capture
      screenshot = exclude(screenshot, @element_to_exclude) if @element_to_exclude
      Gatling::ImageWrangler.crop_element(screenshot, @element_to_capture)
    end

    def capture
      temp_dir = "#{@reference_image_path}/temp"
      #captures the uncropped full screen
      begin

        Capybara.page.driver.browser.save_screenshot("#{temp_dir}/temp.png")
        temp_screenshot = Magick::Image.read("#{temp_dir}/temp.png").first
      rescue
        raise "Could not save screenshot to #{temp_dir}. Please make sure you have permission"
      end
    end

    def save_element(image, image_name, path)
      begin
        image.write("#{path}/#{image_name}.png")
        image = "#{path}/#{image_name}.png"
      rescue
        raise "Could not save #{image_name} to #{path}. Please make sure you have permission"
      end
    end

  end
end