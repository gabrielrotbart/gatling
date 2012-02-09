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

        @capture_element = Gatling::CaptureElement.new(@actual)

        @reference_image_path = Gatling::Configuration.reference_image_path
        @expected_image = "#{@reference_image_path}/#{@expected}"
        @expected_filename = "#{@expected}".sub(/\.[a-z]*/,'')
      end

      def create_diff
        diff_path = "#{@reference_image_path}/diff"

        FileUtils::mkdir_p(diff_path)

        @diff_metric.first.write("#{diff_path}/#{@expected_filename}_diff.png")

        candidate = save_crop_as_reference(@cropped_element)
        raise "element did not match #{@expected}. A diff image: #{@expected_filename}_diff.png was created in #{diff_path}. A new reference #{candidate} can be used to fix the test"
      end

      def save_element_as_reference(element)
        candidate_path = "#{@reference_image_path}/candidate"
        @capture_element.save_element(element, @expected_filename, candidate_path)
      end

      def matches?
        @cropped_element = @capture_element.crop
        if File.exists?(@expected_image)

          expected_img = Magick::Image.read(@expected_image).first

          @diff_metric = @cropped_element.compare_channel(expected_img, Magick::MeanAbsoluteErrorMetric)

          matches = @diff_metric[1] == 0.0

          create_diff unless matches

          matches
        else
          candidate = save_element_as_reference(@cropped_element)
          raise "The design reference #{@expected} does not exist, #{candidate} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
        end
      end
    end

    class CaptureElement

      def initialize element_to_capture
        @reference_image_path = Gatling::Configuration.reference_image_path
        @element = element_to_capture
      end

      def capture
        temp_dir = "#{@reference_image_path}/temp"

        FileUtils::mkdir_p(temp_dir)

        #captures the uncropped full screen
        page.driver.browser.save_screenshot("#{temp_dir}/temp.png")
        temp_screenshot = Magick::Image.read("#{temp_dir}/temp.png").first
      end

      def crop
        element = @element.native
        location = element.location
        size = element.size
        @cropped_element = self.capture.crop(location.x, location.y, size.width, size.height)
      end

      def save_element(element, element_name, path)
        FileUtils::mkdir_p(path)

        element.write("#{path}/#{element_name}.png")
        element = "#{path}/#{element_name}.png"
      end


    end

    class Trainer < Comparison

      def initialize actual, expected
        @reference_image_path = Gatling::Configuration.reference_image_path

        @expected_filename = "#{expected}".sub(/\.[a-z]*/,'')

        @actual = actual
        @cropped_element = Gatling::CaptureElement.new(@actual)
      end

      def create_reference
        reference = @cropped_element.crop
        @cropped_element.save_element(reference, @expected_filename, @reference_image_path)
      end

      #overrides Comparison matches command in order to save the initial references
      def matches?
        self.create_reference
      end

      def run
        self.matches?
      end
      #trainer will create candidates and move them to the correct folder
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




