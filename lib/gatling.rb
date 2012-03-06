require 'RMagick'
require_relative 'gatling/capture_element'
require 'capybara'
require 'capybara/dsl'
require 'gatling/config'
require 'gatling/file_helper'
require 'gatling/image'


module Gatling
  class Comparison
    include Capybara::DSL

    #TODO: Training mode
    #TODO: Diff with reports
    #TODO: Fuzz matches
    #TODO: Helpers for cucumber

    def initialize expected_image_name, actual_element

      puts "expected = '#{expected_image_name}'"
      @expected_image_name = expected_image_name#.sub(/\.[a-z]*/,'')
      puts "expected image _name= '#{@expected_image_name}'"
      @actual_element = actual_element

      @reference_image_path = Gatling::Configuration.reference_image_path
      @trainer_toggle = Gatling::Configuration.trainer_toggle

      @expected_image_path = "#{@reference_image_path}/#{@expected_image_name}"
      @expected_filename = expected_image_name

      @file_helper = Gatling::FileHelper.new
      @file_helper.make_required_directories
    end

    def matches?
      @actual_image = Gatling::CaptureElement.new(@actual_element).capture
      if !@trainer_toggle
        if @file_helper.exists?(@expected_image_name, :reference)
          self.compare
        else
          candidate_image_path = @file_helper.save_image(@actual_image, @expected_filename, :candidate)
          raise "The design reference #{@expected_image_name} does not exist, #{candidate_image_path} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
        end
      else
        save_image_as_reference(@actual_image)
        matches = true
      end
    end

    def save_diff diff_metric
      diff_path = @file_helper.save_image(diff_metric.first, @expected_filename, :diff)

      candidate_image_path = @file_helper.save_image(@actual_image, @expected_filename, :candidate)
      raise "element did not match #{@expected_image_name}. A diff image: #{@expected_filename} was created in #{diff_path}. A new reference #{candidate_image_path} can be used to fix the test"
    end

    def compare
      expected_image = Magick::Image.read(@expected_image_path).first

      diff_metric = @actual_image.compare_channel(expected_image, Magick::MeanAbsoluteErrorMetric)

      matches = diff_metric[1] == 0.0

      save_diff(diff_metric) unless matches

      matches
    end

    private

    def save_image_as_reference(image)
      if File.exists?(@expected_image_path) == false
        @file_helper.save_image(image, @expected_filename, :reference)
        puts "Saved #{@expected_image_path} as reference"
      else
        puts "#{@expected_image_path} ALREADY EXISTS. REFERENCE IMAGE WAS NOT OVERWRITTEN. PLEASE DELETE THE OLD FILE TO UPDATE USING TRAINER"
      end
    end

  end

end




