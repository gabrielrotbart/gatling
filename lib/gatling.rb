require "gatling/version"
require 'RMagick'
include Magick

# The Gatling Comparison class allows you to build an Rspec / Capybara custom matcher comparing a :css or :xpath element to a referenced screenshot:
# Example:
# -----------
# RSpec::Matchers.define :look_like do |expected|
#   match do |actual|
#     Gatling::Comparison.new(expected, actual).matches?
#   end
# end
# -----------

module Gatling
    class Comparison

      def initialize expected, actual
        @expected = expected
        @actual = actual
      end

      def capture
        page.driver.browser.save_screenshot('temp.png')
        temp_screenshot = Image.read('temp.png').first
      end

      def crop_element
        element = @actual.native
        location = element.location
        size = element.size
        capture.crop(location.x, location.y, size.width, size.height)
      end

      def save_crop_as_reference(cropped_element)   
        filename = "#{@expected}".sub(/\.[a-z]*/,'')
        cropped_element.write("#{filename}_candidate.png")
        return filename
      end   


      def matches?
        cropped_element = crop_element
        if File.exists?(@expected)
          expected_img = Image.read(@expected).first
          diff_metric = cropped_element.compare_channel(expected_img, MeanAbsoluteErrorMetric)
          matches = diff_metric[1] == 0.0
          diff_metric.first.write('diff.png') unless matches
          matches
        else
          filename = save_crop_as_reference(cropped_element)
          raise "The design reference #{@expected} does not exist, #{filename}_candidate.png is now available to be used as a reference"     
        end    
      end      
    end
  end
