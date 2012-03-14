module Gatling
  class Comparison

    attr_accessor :match, :diff_image

    def initialize(actual_image, expected_image)
      compare(actual_image, expected_image)
    end

    def compare(actual_image, expected_image)
      diff_metric = actual_image.image.compare_channel(expected_image.image, Magick::MeanAbsoluteErrorMetric)
      @match = diff_metric[1] == 0.0
      unless @match
        diff_image = diff_metric.first
        @diff_image = Gatling::Image.new(:from_diff, actual_image.file_name, diff_image)
      end
      @match
    end

    def diff_image
      @diff_image
    end

  end
end