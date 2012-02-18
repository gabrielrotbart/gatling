require 'RMagick'
require_relative 'gatling/capture_element'
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
        @trainer_toggle = Gatling::Configuration.trainer_toggle

        @expected_image = "#{@reference_image_path}/#{@expected}"
        @expected_filename = "#{@expected}".sub(/\.[a-z]*/,'')
        
      end

      def create_diff
        diff_path = "#{@reference_image_path}/diff"

        FileUtils::mkdir_p(diff_path)

        @diff_metric.first.write("#{diff_path}/#{@expected_filename}_diff.png")

        candidate = save_element_as_candidate(@cropped_element)
        raise "element did not match #{@expected}. A diff image: #{@expected_filename}_diff.png was created in #{diff_path}. A new reference #{candidate} can be used to fix the test"
      end

      def save_element_as_candidate(element)
        candidate_path = "#{@reference_image_path}/candidate"
        candidate = @capture_element.save_element(element, @expected_filename, candidate_path)
      end

      def save_element_as_reference(element)
          @capture_element.save_element(element, @expected_filename, @reference_image_path)
          puts "Saved #{@expected_image} as reference"
      end

      def matches?               
        @cropped_element = @capture_element.crop
        if !@trainer_toggle
          if File.exists?(@expected_image)
            self.compare
          else
            candidate = self.save_element_as_candidate(@cropped_element)
            raise "The design reference #{@expected} does not exist, #{candidate} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
          end
        else
          self.save_element_as_reference(@cropped_element)
        end
      end

      def compare
        expected_img = Magick::Image.read(@expected_image).first

        @diff_metric = @cropped_element.compare_channel(expected_img, Magick::MeanAbsoluteErrorMetric)

        matches = @diff_metric[1] == 0.0

        create_diff unless matches

        matches
      end
    end

end




