require 'RMagick'

module Gatling
    class Comparison
      
      #TODO: Training mode
      #TODO: Diff with reports
      #TODO: Canidate in spec
      #TODO: Fuzz matches
      #TODO: Helpers for cucumber

      def initialize expected, actual
        @expected = expected
        @actual = actual
      end

            
      def capture
        temp_dir = "#{@reference_image_path}/temp"
        
        FileUtils::mkdir_p(temp_dir) unless File.exists?(temp_dir)
        
        #captures the uncropped full screen
        page.driver.browser.save_screenshot("#{temp_dir}/temp.png")
        temp_screenshot = Magick::Image.read("#{temp_dir}/temp.png").first
      end

      def crop_element
        element = @actual.native
        location = element.location
        size = element.size
        capture.crop(location.x, location.y, size.width, size.height)
      end

      def save_crop_as_reference(cropped_element)
        candidate_path = "#{@reference_image_path}/candidate"
        
        FileUtils::mkdir_p(candidate_path) unless File.exists?(candidate_path)
           
        filename = "#{@expected}".sub(/\.[a-z]*/,'')
        cropped_element.write("#{candidate_path}/#{filename}_candidate.png")
        candidate = "#{candidate_path}/#{filename}_candidate.png"
      end   


      def matches?
        @reference_image_path = Gatling::Configuration.reference_image_path
        cropped_element = crop_element
        if File.exists?(@expected)
          expected_img = Magick::Image.read(@expected).first
          diff_metric = cropped_element.compare_channel(expected_img, Magick::MeanAbsoluteErrorMetric)
          matches = diff_metric[1] == 0.0
          diff_metric.first.write('diff.png') unless matches
          matches
        else
          candidate = save_crop_as_reference(cropped_element)
          raise "The design reference #{@expected} does not exist, #{candidate} is now available to be used as a reference"     
        end    
      end      
    end
    
    module Configuration

      class << self        

        attr_accessor 'reference_image_path'

        def reference_image_path
          begin
           @reference_image_path ||= File.join(Rails.root, 'spec/reference_images')
          rescue NameError
            puts "Not using Rails? Please set the reference_image_path"
          end  
        end

      end
      
    end
    
end


  

