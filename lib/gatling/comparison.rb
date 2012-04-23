module Gatling
  class Comparison

    attr_accessor :match, :diff_image

    def initialize actual_image, expected_image
      @actual_image = actual_image
      @expected_image = expected_image
    end

    def matches?
      diff_metric = @actual_image.image.compare_channel(@expected_image.image, Magick::MeanAbsoluteErrorMetric)
      @match = diff_metric[1] == 0.0
    end

    def diff_image
      diff_image = @actual_image.image.compare_channel(@expected_image.image, Magick::MeanAbsoluteErrorMetric).first
      Gatling::Image.new(diff_image, @expected_image.file_name)
    end

  end
end