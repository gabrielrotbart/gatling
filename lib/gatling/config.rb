require 'logger'

module Gatling
  module Configuration

    class << self

      attr_accessor :reference_image_path, :trainer_toggle, :max_no_tries, :sleep_between_tries, :browser_ref_paths_toggle

      attr_reader :paths

      def reference_image_path
        @reference_image_path ||= construct_path
      end

      def max_no_tries
        Gatling.max_no_tries || @max_no_tries ||= 5
      end

      def sleep_between_tries
        Gatling.sleep_between_tries || @sleep_between_tries ||= 0.5
      end

      def path(type)
        paths = Hash[:reference => reference_image_path,
                    :candidate => File.join(reference_image_path, 'candidate'),
                    :diff => File.join(reference_image_path, 'diff'),
                    :temp => File.join(reference_image_path, 'temp')]
        if paths.keys.include? type
          return paths[type]
        else
          raise "Unkown image type '#{type}'"
        end
      end

      def trainer_toggle
        @trainer_value = ENV['GATLING_TRAINER']

        case @trainer_value
        when nil
          @trainer_value = nil
        when 'true'
          @trainer_value = true
        when 'false'
          @trainer_value = false
        else
          @trainer_value = false
          puts 'Unknown GATLING_TRAINER argument. Please supply true, false or nil. DEFAULTING TO FALSE'
        end
        @trainer_toggle ||= @trainer_value ||= false
      end


      def construct_path
        private
          if Gatling.reference_image_path
            reference_image_path = Gatling.reference_image_path
          else
            begin
              reference_image_path = File.join(Rails.root, 'spec/reference_images')
            rescue
              reference_image_path = 'spec/reference_images'
              puts "Currently defaulting to #{@reference_image_path}. Overide this by setting Gatling::Configuration.reference_image_path=[refpath]"
            end
          end
          if browser_ref_paths_toggle
            begin
              File.join(reference_image_path, browser)
            rescue
              reference_image_path
            end
           else
            reference_image_path
          end
      end

      def browser_ref_paths_toggle
        Gatling.browser_ref_paths_toggle || @browser_ref_paths_toggle ||= false
      end

      def browser
        begin
          browser = Capybara.page.driver.browser.browser
        rescue
          raise "Currently custom folders are only supported by Capybara. ENV variables are coming."
        end
        browser.to_s
      end

    end

  end
end
