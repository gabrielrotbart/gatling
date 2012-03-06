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

    def initialize expected_filename, actual_element
      @expected_filename = expected_filename
      @actual_element = actual_element
     
      @file_helper = Gatling::FileHelper.new
      @file_helper.make_required_directories    
    end

    def matches?
      @actual_image = Gatling::CaptureElement.new(@actual_element).capture

      if Gatling::Configuration.trainer_toggle
        save_image_as_reference(@actual_image)
        return true
      end

      if @file_helper.exists?(@expected_filename, :reference)
        expected_image = @file_helper.load(@expected_filename, :reference)
        compare expected_image
      else
        candidate_image_path = @file_helper.save_image(@actual_image, @expected_filename, :candidate)
        raise "The design reference #{@expected_filename} does not exist, #{candidate_image_path} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
      end
    end

    def save_diff diff_metric
      diff_path = @file_helper.save_image(diff_metric.first, @expected_filename, :diff)

      candidate_image_path = @file_helper.save_image(@actual_image, @expected_filename, :candidate)
      raise "element did not match #{@expected_filename}. A diff image: #{@expected_filename} was created in #{diff_path}. A new reference #{candidate_image_path} can be used to fix the test"
    end

    def compare(expected_image)
      
      diff_metric = Gatling::ImageWrangler.compare(expected_image, @actual_image)
      matches = diff_metric[1] == 0.0
      save_diff(diff_metric) unless matches
      matches
    end

    private

    def save_image_as_reference(image)
      if @file_helper.exists?(@expected_filename, :reference) == false
        refernece_path = @file_helper.save_image(image, @expected_filename, :reference)
        puts "Saved #{@refernece_path} as reference"
      else
        puts "#{@refernece_path} ALREADY EXISTS. REFERENCE IMAGE WAS NOT OVERWRITTEN. PLEASE DELETE THE OLD FILE TO UPDATE USING TRAINER"
      end
    end

  end

end




