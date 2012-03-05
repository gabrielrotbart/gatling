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

    def initialize expected, actual
      @expected = expected
      @actual = actual

      @capture_element = Gatling::CaptureElement.new(@actual)

      @reference_image_path = Gatling::Configuration.reference_image_path
      @trainer_toggle = Gatling::Configuration.trainer_toggle

      @expected_image = "#{@reference_image_path}/#{@expected}"
      @expected_filename = "#{@expected}".sub(/\.[a-z]*/,'')
      @file_helper = Gatling::FileHelper.new
      @file_helper.make_required_directories
    end

    def matches?
      @cropped_image = @capture_element.into_image
      if !@trainer_toggle
        if File.exists?(@expected_image)
          self.compare
        else
          candidate_image_path = @file_helper.save_image_as_candidate(@cropped_image, @expected_filename)
          raise "The design reference #{@expected} does not exist, #{candidate_image_path} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
        end
      else
        save_image_as_reference(@cropped_image)
        matches = true
      end
    end

    def save_diff diff_metric
      #diff = Gatling::Image.new(rmagic_image:diff_metric.first, name:"#{@expected_filename}_diff", type:diff)
      #@file_helper.save_gatling_image diff
      diff_path = @file_helper.save_image_as_diff(diff_metric.first, "#{@expected_filename}_diff")

      candidate_image_path = @file_helper.save_image_as_candidate(@cropped_image, @expected_filename)
      raise "element did not match #{@expected}. A diff image: #{@expected_filename}_diff.png was created in #{diff_path}. A new reference #{candidate_image_path} can be used to fix the test"
    end

    def compare
      expected_img = Magick::Image.read(@expected_image).first

      diff_metric = @cropped_image.compare_channel(expected_img, Magick::MeanAbsoluteErrorMetric)

      matches = diff_metric[1] == 0.0

      save_diff(diff_metric) unless matches

      matches
    end

    private

    def save_image_as_reference(image)
      if File.exists?(@expected_image) == false
        @file_helper.save_image(image, @expected_filename, :reference)
        puts "Saved #{@expected_image} as reference"
      else
        puts "#{@expected_image.upcase} ALREADY EXISTS. REFERENCE IMAGE WAS NOT OVERWRITTEN. PLEASE DELETE THE OLD FILE TO UPDATE USING TRAINER"
      end
    end

  end

end




