require 'RMagick'
require 'capybara'
require 'capybara/dsl'

require 'gatling/configuration'
require 'gatling/image'
require 'gatling/comparison'
require 'gatling/capture_element'


#TODO: Helpers for cucumber
#TODO: Make directories as needed

module Gatling
  class << self

    def matches?(expected_reference_filename, actual_element)

      if ENV['GATLING_TRAINER']
        raise 'GATLING_TRAINER has been depreciated. Gatling will now create reference files where ones are missing. Delete bad references and re-run Gatling to re-train'
      end

      @actual_element = actual_element
      @expected_reference_filename = expected_reference_filename
      @expected_reference_file = (File.join(Gatling::Configuration.path(:reference), expected_reference_filename))


      if !File.exists?(@expected_reference_file)
        save_reference
        return true
      else
        reference_file = Gatling::ImageFromFile.new(expected_reference_filename)
        comparison = compare_until_match(actual_element, reference_file, Gatling::Configuration.max_no_tries)
        matches = comparison.matches?
        if !matches
          comparison.actual_image.save(:candidate)
          save_image_as_diff(comparison.diff_image)
        end
        matches
      end
    end

    def compare_until_match actual_element, reference_file, max_no_tries = Gatling::Configuration.max_no_tries, sleep_time = Gatling::Configuration.sleep_between_tries
      max_no_tries.times do |i|
        actual_image = Gatling::ImageFromElement.new(actual_element, reference_file.file_name)
        @comparison = Gatling::Comparison.new(actual_image, reference_file)
        match = @comparison.matches?
        if !match
          sleep sleep_time
          #TODO: Send to logger instead of puts
          i += 1
          puts "Tried to match #{i} times"
        else
          return(@comparison)
        end
      end
      @comparison
    end

    def save_image_as_diff(image)
      image.save(:diff)
      raise "element did not match #{image.file_name}. A diff image: #{image.file_name} was created in " +
      "#{image.path(:diff)} " +
      "A new reference #{image.path(:candidate)} can be used to fix the test"
    end

    def save_image_as_candidate(image)
      image.save(:candidate)
      raise "The design reference #{image.file_name} does not exist, #{image.path(:candidate)} " +
      "is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference"
    end

    def save_reference
      ImageFromElement.new(@actual_element,@expected_reference_filename).verify_and_save
    end

    def config(&block)
      begin
        config_class = Gatling::Configuration
        raise "No block provied" unless block_given?
        block.call(config_class)
      rescue
         raise "Config block has changed. Example: Gatling.config {|c| c.reference_image_path = 'some/path'}. Please see README"
      end
    end

  end
end
