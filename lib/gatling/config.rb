module Gatling
  module Configuration

    class << self

      attr_accessor :reference_image_path, :trainer_toggle, :match_tries, :sleep_between_tries

      attr_reader :paths

      def reference_image_path
        @reference_image_path ||= set_default_path
      end

      def match_tries
        @match_tries ||= 5
      end

      def sleep_between_tries
        @sleep_between_tries ||= 0.5
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




      def set_default_path
        private
        begin
          @reference_image_path ||= File.join(Rails.root, 'spec/reference_images')
        rescue
          @reference_image_path = 'spec/reference_images'
          puts "Currently defaulting to #{@reference_image_path}. Overide this by setting Gatling::Configuration.reference_image_path=[refpath]"
        end
        @reference_image_path
      end
    end

  end
end
