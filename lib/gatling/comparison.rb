module Gatling
  class Comparison

    attr_accessor :diff_image, :actual_image, :expected_image

    def initialize actual_image, expected_image
      @actual_image = actual_image
      @expected_image = expected_image
      @comparison = compare_image
      @match = @comparison[1] == 0.0
      if !@matches
         @diff_image =Gatling::Image.new(@comparison.first, @expected_image.file_name)
      end
    end

    def matches?
      @match
    end

    def compare_image
      compare_images_with_same_size? ? compare_images_with_same_size : compare_images_with_different_size
    end

    def compare_images_with_same_size
      images_to_compare = prep_images_for_comparison
      images_to_compare.first.compare_channel(images_to_compare.last, Magick::MeanAbsoluteErrorMetric)
    end

    def compare_images_with_different_size
      row = [@actual_image.image.rows, @expected_image.image.rows].max
      column = [@actual_image.image.columns, @expected_image.image.columns].max

      images_to_compare = prep_images_for_comparison do |image|
        expanded_image = image.extent(column, row)
        expanded_image.background_color = 'white'
        expanded_image
      end
      images_to_compare.first.compare_channel(images_to_compare.last, Magick::MeanAbsoluteErrorMetric)
    end

    def compare_images_with_same_size?
      @actual_image.image.rows == @expected_image.image.rows && @actual_image.image.columns == @expected_image.image.columns
    end

    def prep_images_for_comparison
      [
          @actual_image,
          @expected_image,
      ].collect do |gatling_image|
        image = gatling_image.image.clone
        image = yield image if block_given?

        # Important: ensure the image 0,0 is reset to the top-left of the image before comparison
        image.offset = 0
        image
      end
    end

  end
end