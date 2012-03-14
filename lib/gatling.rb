Dir["/gatling/*.rb"].each {|file| require file}

require 'RMagick'
require_relative 'gatling/capture_element'
require 'capybara'
require 'capybara/dsl'
require 'gatling/config'
require 'gatling/file_helper'
require 'gatling/image'
require 'gatling/comparison'

#TODO: Diff with reports
#TODO: Fuzz matches
#TODO: Helpers for cucumber

#TODO: Listen to Gabe and diferentiate between different types of image sources
#TODO: Lazy evaluation of images so that it only happens at compare time
#TODO: rename Gatling::Image to something more meaningful
#TODO: Make directories as needed

module Gatling

  class << self

    def matches?(expected_reference_filename, actual_element)

      Gatling::FileHelper.make_required_directories

      @expected_reference_file = (File.join(Gatling::Configuration.paths[:reference], expected_reference_filename))
      @actual_image = Gatling::Image.new(:from_element, expected_reference_filename, actual_element)

      if Gatling::Configuration.trainer_toggle
        save_image_as_reference(@actual_image)
        return true
      end

      if !File.exists?(@expected_reference_file)
        @actual_image.save :as => :candidate
        raise "The design reference #{@actual_image.file_name} does not exist, #{@actual_image.path} " +
        "is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
        return false
      else
        @expected_image = Gatling::Image.new(:from_file, expected_reference_filename)
        comparison = Gatling::Comparison.new
        comparison.compare(@expected_image,@actual_image)
        unless comparison.matches?
          raise "element did not match #{@expected_image.file_name}. A diff image: #{@actual_image.file_name} was created in " +
          "#{File.join(Gatling::Configuration.paths[:diff],@actual_image.file_name)}. " +
          "A new reference #{File.join(Gatling::Configuration.paths[:candidate],@actual_image.file_name)} can be used to fix the test"
        end
        comparison.matches?
      end
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
