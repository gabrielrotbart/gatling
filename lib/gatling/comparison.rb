module Gatling
  class Comparison
    
      include Capybara::DSL

      #TODO: Diff with reports
      #TODO: Fuzz matches
      #TODO: Helpers for cucumber

      #TODO: Listen to Gabe and diferentiate between different types of image sources
      #TODO: Lazy evaluation of images so that it only happens at compare time
      #TODO: rename Gatling::Image to something more meaningful
      #TODO: Make directories as needed

      def initialize expected_filename, actual_element
        # Gatling::FileHelper.make_required_directories

        @actual_element = actual_element

        @expected_image = Gatling::Image.new(:from_file, expected_filename)
      end
      
      def compare(expected_image, actual_image)
        diff_metric = Gatling::ImageWrangler.compare(expected_image, actual_image)

        matches = diff_metric[1] == 0.0

        if !matches
          diff_image = Gatling::Image.new(type, diff_image, file_name)
          diff_image.file_name = actual_image.file_name
          diff_image.rmagick_image = diff_metric.first
          diff_image.save(:as => :diff)

          diff_image.save screen_shot, file_name

          actual_image.save(:as => :candidate)
          raise "element did not match #{actual_image.file_name}. A diff image: #{diff_image.file_name} was created in #{diff_image.path}. A new reference #{actual_image.path} can be used to fix the test"

        end
        matches
      end
    
    
  end
end