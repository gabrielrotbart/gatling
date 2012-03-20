#Dir["/gatling/*.rb"].each {|file| require file}

require 'RMagick'
require 'capybara'
require 'capybara/dsl'

require 'gatling/config'
require 'gatling/image'
require 'gatling/comparison'
require 'gatling/capture_element'

# include Gatling::Comparison

#TODO: Fuzz matches
#TODO: Helpers for cucumber
#TODO: Make directories as needed

module Gatling

  class << self

    def matches?(expected_reference_filename, actual_element)

      expected_reference_file = (File.join(Gatling::Configuration.paths[:reference], expected_reference_filename))
      actual_image = Gatling::Image.new(:from_element, expected_reference_filename, actual_element)

      if Gatling::Configuration.trainer_toggle
        save_image_as_reference(actual_image)
        return true
      end

      if !File.exists?(expected_reference_file)
        save_image_as_candidate(actual_image)
        return false
      else
        expected_image = Gatling::Image.new(:from_file, expected_reference_filename)
        comparison = Gatling::Comparison.new(expected_image, actual_image)
        unless comparison.match
          actual_image.save(:as => :candidate)
          save_image_as_diff(comparison.diff_image)
        end
        comparison.match
      end
    end

    private

    def save_image_as_diff(image)
      image.save(:as => :diff)
      raise "element did not match #{image.file_name}. A diff image: #{image.file_name} was created in " +
      "#{File.join(Gatling::Configuration.paths[:diff],image.file_name)}. " +
      "A new reference #{File.join(Gatling::Configuration.paths[:candidate],image.file_name)} can be used to fix the test"
    end

    def save_image_as_candidate(image)
      image.save :as => :candidate
      raise "The design reference #{image.file_name} does not exist, #{image.path} " +
      "is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
    end

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
