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

      begin
        FileUtils::mkdir_p(temp_dir)
      rescue
        puts "Could not create directory #{temp_dir}. Please make sure you have permission"
      end

      #captures the uncropped full screen
      begin

        Capybara.page.driver.browser.save_screenshot("#{temp_dir}/temp.png")
        temp_screenshot = Magick::Image.read("#{temp_dir}/temp.png").first
      rescue
        raise "Could not save screenshot to #{temp_dir}. Please make sure you have permission"
      end
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

    # def save_element_as_candidate(element)
    #   candidate_path = "#{@reference_image_path}/candidate"
    #   candidate = @capture_element.save_element(element, @expected_filename, candidate_path)
    # end

    # def save_element_as_reference(element)
    #   if File.exists?(@expected_image) == false
    #     @capture_element.save_element(element, @expected_filename, @reference_image_path)
    #     puts "Saved #{@expected_image} as reference"
    #   else
    #     puts "#{@expected_image.upcase} ALREADY EXISTS. REFERENCE IMAGE WAS NOT OVERWRITTEN. PLEASE DELETE THE OLD FILE TO UPDATE USING TRAINER"
    #   end
    # end
  
  end
end