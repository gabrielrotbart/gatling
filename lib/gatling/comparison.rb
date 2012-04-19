module Gatling
  class Comparison

    attr_accessor :match, :diff_image

    def initialize actual_image, expected_image
      @actual_image = actual_image
      @expected_image = expected_image
    end

    def matches?
      times = 5
      try = 1
      @match = false
      while @match = false || try < times+1
        diff_metric = @actual_image.image.compare_channel(@expected_image.image, Magick::MeanAbsoluteErrorMetric)
        puts "Tried to match #{try}"
        try+=1
        return @match = diff_metric[1] == 0.0
      end
    end

    def diff_image
      diff_image = @actual_image.image.compare_channel(@expected_image.image, Magick::MeanAbsoluteErrorMetric).first
      Gatling::Image.new(:from_diff, diff_image)
    end

  end
end