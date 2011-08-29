require 'spec_helper'
include Capybara::DSL
include Magick


class Comparison

  def initialize expected, actual
    @expected = expected
    @actual = actual
  end
  
  def capture
    page.driver.browser.save_screenshot('temp.png')
    temp_screenshot = Image.read('temp.png').first
  end
  
  def cropped_element
    element = @actual.native
    location = element.location
    size = element.size
    capture.crop(location.x, location.y, size.width, size.height)
  end
    
  def matches?
    cropped_element.write("cropped.png")
    raise "The design reference #{@expected} does not exist" unless File.exists? "google_logo.png"
    
    #compares actual and expected
    expected_img = Image.read(@expected).first
    diff_metric = cropped_element.compare_channel(expected_img, MeanAbsoluteErrorMetric)
    matches = diff_metric[1] == 0.0
    diff_metric.first.write('diff.png') unless matches
    matches    
  end
end

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    Comparison.new(expected, actual).matches?
  end
end


describe "Google search" do
  it "blah" do
   visit('/')
   page.find(:css, '#hplogo').should look_like('google_logo.png')
  end
end



