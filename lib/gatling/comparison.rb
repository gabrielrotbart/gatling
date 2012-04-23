module Gatling
  class Comparison

    attr_accessor :diff_image, :actual_image, :expected_image

    def initialize actual_image, expected_image
      @actual_image = actual_image
      @expected_image = expected_image
      @comparison = @actual_image.image.compare_channel(@expected_image.image, Magick::MeanAbsoluteErrorMetric)
      @match = @comparison[1] == 0.0
      if !@matches
         @diff_image =Gatling::Image.new(@comparison.first, @expected_image.file_name)
      end
    end

    def matches?
      @match
    end

  end
end