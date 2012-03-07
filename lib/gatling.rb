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

    #TODO: Listen to Gabe and diferentiate between different types of image sources
    #TODO: Lazy evaluation of images so that it only happens at compare time
    #TODO: rename Gatling::Image to something more meaningful
    #TODO: Make directories as needed

    def initialize expected_filename, actual_element  
      Gatling::FileHelper.make_required_directories 

      #image taken from the web element
      @actual_image = Gatling::Image.new
      @actual_image.base_on_element(actual_element)
      @actual_image.file_name = expected_filename

      #reference image that may exist on the file system
      @expected_image = Gatling::Image.new
      @expected_image.file_name = expected_filename
    end

    def matches?
      if Gatling::Configuration.trainer_toggle
        save_image_as_reference(@actual_image)
        return true
      end

      if !@expected_image.exists?
        @actual_image.save :as => :candidate
        raise "The design reference #{@actual_image.file_name} does not exist, #{@actual_image.path} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
      else
        @expected_image.base_on_file @expected_image.file_name
        compare @expected_image, @actual_image
      end
    end

    def compare(expected_image, actual_image)         
      diff_metric = Gatling::ImageWrangler.compare(expected_image, actual_image)

      matches = diff_metric[1] == 0.0

      if !matches
        diff_image = Gatling::Image.new
        diff_image.file_name = actual_image.file_name
        diff_image.rmagick_image = diff_metric.first
        diff_image.save(:as => :diff)

        actual_image.save(:as => :candidate) 
        raise "element did not match #{actual_image.file_name}. A diff image: #{diff_image.file_name} was created in #{diff_image.path}. A new reference #{actual_image.path} can be used to fix the test"
      
      end
      matches   
    end

    private

    def save_image_as_reference(image)
      if image.exists?
        puts "#{image.path} already exists. reference image was not overwritten. please delete the old file to update using trainer"
      else
        image.save(:as => :reference)
        puts "Saved #{image.path} as reference"     
      end
    end
  end
end




