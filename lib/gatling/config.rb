module Gatling 
 module Configuration

    class << self

      attr_accessor 'reference_image_path', 'trainer_toggle'

      def reference_image_path
        begin
        @reference_image_path ||= File.join(Rails.root, 'spec/reference_images')
        rescue
          raise "Not using Rails? Please set the reference_image_path"
        end
      end

      def trainer_toggle
        @trainer_toggle ||= false
      end

    end

  end
end