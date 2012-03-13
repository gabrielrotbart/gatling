module Gatling
  class Comparison

    include Capybara::DSL

    attr_accessor :match, :diff_image

    def initialize
    end

    def compare(actual_image, expected_image)
      require 'pry'
      binding.pry
      diff_metric = actual_image.image.compare_channel(expected_image.image, Magick::MeanAbsoluteErrorMetric)
      @match = diff_metric[1] == 0.0
      unless @match
        diff_image = diff_metric.first
        diff_image = Gatling::Image.new(:from_diff, actual_image.file_name, diff_image)
        diff_image.save(:as => :diff)
        actual_image.save(:as => :candidate)
      end
    end

    def matches?
      @match
    end

  end
end