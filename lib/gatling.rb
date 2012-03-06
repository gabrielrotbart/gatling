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
      @image_filename = expected_filename
      @actual_element = actual_element
     
      Gatling::FileHelper.make_required_directories    
      @actual_image = Gatling::Image.new
      @actual_image.base_on_element(@actual_element)
      @actual_image.file_name = @image_filename

      @expected_image = Gatling::Image.new
      @expected_image.file_name  = @image_filename
    end

    def matches?
      if Gatling::Configuration.trainer_toggle
        save_image_as_reference(@actual_image)
        return true
      end

      if @expected_image.exists?
        @expected_image.base_on_file @expected_image.file_name
        compare @expected_image, @actual_image
      else
        candidate_image_path = @actual_image.save :as => :candidate
        raise "The design reference #{@actual_image.file_name} does not exist, #{candidate_image_path} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
      end
    end

    def save_diff diff_metric
      diff_path = Gatling::FileHelper.save_image(diff_metric.first, @image_filename, :diff)
      candidate_image_path = @actual_image.save(:as => :candidate)
      raise "element did not match #{@actual_image.file_name}. A diff image: #{@actual_image.file_name} was created in #{diff_path}. A new reference #{candidate_image_path} can be used to fix the test"
    end

    def compare(expected_image, actual_image)    
      diff_metric = Gatling::ImageWrangler.compare(expected_image.rmagick_image, actual_image.rmagick_image)
      matches = diff_metric[1] == 0.0
      save_diff(diff_metric) unless matches
      matches
    end

    private

    def save_image_as_reference(image)
      if Gatling::FileHelper.exists?(@image_filename, :reference) == false
        reference_path = @actual_image.save(:as => :reference)
        puts "Saved #{reference_path} as reference"
      else
        puts "#{reference_path} ALREADY EXISTS. REFERENCE IMAGE WAS NOT OVERWRITTEN. PLEASE DELETE THE OLD FILE TO UPDATE USING TRAINER"
      end
    end

  end

end




