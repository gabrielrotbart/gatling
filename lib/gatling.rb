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

    attr_accessor :reference_file_name

    def matches?(expected_reference_filename, actual_element)

      @reference_file_name = expected_reference_filename

      expected_reference_file = (File.join(Gatling::Configuration.path(:reference), expected_reference_filename))


      if Gatling::Configuration.trainer_toggle
        actual_image = Gatling::ImageFromElement.new(actual_element, expected_reference_filename)
        save_image_as_reference(actual_image)
        return true
      end

      if !File.exists?(expected_reference_file)
        actual_image = Gatling::ImageFromElement.new(actual_element, expected_reference_filename)
        save_image_as_candidate(actual_image)
        return false
      else
        comparison = compare_until_match(actual_element, expected_reference_filename, 5)
        matches = comparison.matches?
        if !matches
          comparison.actual_image.save(:as => :candidate)
          save_image_as_diff(comparison.diff_image)
        end
        matches
      end
    end

    def compare_until_match actual_element, expected_reference_filename, max_no_tries
      tries = max_no_tries
      try = 0
      match = false
      expected_image = Gatling::ImageFromFile.new(expected_reference_filename)
      comparison = nil
      while !match && try < tries
        actual_image = Gatling::ImageFromElement.new(actual_element, expected_reference_filename)
        comparison = Gatling::Comparison.new(expected_image, actual_image)
        match = comparison.matches?
        if !match
          sleep 0.5
          try += 1
          puts "Tried to match #{try} times"
        end
      end
      comparison
    end

    def save_image_as_diff(image)
      image.save(:as => :diff)
      raise "element did not match #{image.file_name}. A diff image: #{image.file_name} was created in " +
      "#{File.join(Gatling::Configuration.path(:diff),image.file_name)}. " +
      "A new reference #{File.join(Gatling::Configuration.path(:candidate),image.file_name)} can be used to fix the test"
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
