require 'RMagick'
require_relative 'gatling/capture_element'
require 'capybara'
require 'capybara/dsl'
require 'gatling/config'
require 'gatling/file_helper'
require 'gatling/image'


Dir["/gatling/*.rb"].each {|file| require file}

module Gatling
  class Fire

    def initialize expected_reference_filename, actual_element
      Gatling::FileHelper.make_required_directories

      @expected_reference_filename = expected_reference_filename
      @expected_reference_file = (File.join(Gatling::Configuration.paths[:reference],expected_reference_filename))
      @actual_element = actual_element

    end

    def matches?

      @actual_image = Gatling::Image.new(:from_element, @expected_reference_filename, @actual_element)

      if Gatling::Configuration.trainer_toggle
        save_image_as_reference(@actual_image)
        return true
      end

      if !File.exists?(@expected_reference_file)
        @actual_image.save :as => :candidate
        raise "The design reference #{@actual_image.file_name} does not exist, #{@actual_image.path} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
      else
        @expected_image.base_on_file @expected_image.file_name
        compare @expected_image, @actual_image
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




