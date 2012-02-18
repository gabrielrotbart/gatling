module Gatling  
  class CaptureElement

    def initialize element_to_capture
      @reference_image_path = Gatling::Configuration.reference_image_path
      @element = element_to_capture
    end

    def capture
      temp_dir = "#{@reference_image_path}/temp"

      begin
        FileUtils::mkdir_p(temp_dir)
      rescue
        puts "Could not create directory #{temp_dir}. Please make sure you have permission"
      end

      #captures the uncropped full screen
      begin
        page.driver.browser.save_screenshot("#{temp_dir}/temp.png")
        temp_screenshot = Magick::Image.read("#{temp_dir}/temp.png").first
      rescue
        raise "Could not save screenshot to #{temp_dir}. Please make sure you have permission"
      end
    end

    def crop
      element = @element.native
      location = element.location
      size = element.size
      @cropped_element = self.capture.crop(location.x, location.y, size.width, size.height)
    end

    def save_element(element, element_name, path)
      begin
        FileUtils::mkdir_p(path)
      rescue
        puts "Could not create directory #{path}. Please make sure you have permission"
      end

      begin
        element.write("#{path}/#{element_name}.png")
        element = "#{path}/#{element_name}.png"
      rescue
        raise "Could not save #{element_name} to #{path}. Please make sure you have permission"
      end
    end


  end
end