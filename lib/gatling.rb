require 'RMagick'
require 'capybara'
require 'capybara/dsl'


module Gatling
    class Comparison
      include Capybara::DSL
      
      #TODO: Training mode
      #TODO: Diff with reports
      #TODO: Fuzz matches
      #TODO: Helpers for cucumber

      def initialize expected, actual
        @expected = expected
        @actual = actual

        @reference_image_path = Gatling::Configuration.reference_image_path
        @expected_image = "#{@reference_image_path}/#{@expected}"
        @expected_filename = "#{@expected}".sub(/\.[a-z]*/,'')
      end


      def capture
        temp_dir = "#{@reference_image_path}/temp"
        
        FileUtils::mkdir_p(temp_dir)
        
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

        FileUtils::mkdir_p(candidate_path)

        cropped_element.write("#{candidate_path}/#{@expected_filename}.png")
        candidate = "#{candidate_path}/#{@expected_filename}.png"
      end

      def create_diff
        diff_path = "#{@reference_image_path}/diff"

        FileUtils::mkdir_p(diff_path)

        @diff_metric.first.write("#{diff_path}/#{@expected_filename}_diff.png")

        candidate = save_crop_as_reference(@cropped_element)
        raise "element did not match #{@expected}. A diff image: #{@expected_filename}_diff.png was created in #{diff_path}. A new reference #{candidate} can be used to fix the test"
      end


      def matches?
        @cropped_element = crop_element
        if File.exists?(@expected_image)

          expected_img = Magick::Image.read(@expected_image).first

          @diff_metric = @cropped_element.compare_channel(expected_img, Magick::MeanAbsoluteErrorMetric)

          matches = @diff_metric[1] == 0.0

          create_diff unless matches

          matches
        else
          candidate = save_crop_as_reference(@cropped_element)
          raise "The design reference #{@expected} does not exist, #{candidate} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
        end    
      end      
    end
    
    module Configuration

      class << self        

        attr_accessor 'reference_image_path'

        def reference_image_path
          begin
          @reference_image_path ||= File.join(Rails.root, 'spec/reference_images')
          rescue
            raise "Not using Rails? Please set the reference_image_path"
          end
        end

      end
      
    end
    
end


  

