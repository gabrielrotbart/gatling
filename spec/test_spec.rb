require 'spec_helper'
include Capybara::DSL
include Magick

# RSpec::Matchers.define :be_a_multiple_of do |expected|
#   match do |actual|
#     actual % expected == 0
#   end
# end

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    page.driver.browser.save_screenshot('temp.png')
    element = actual
    element = element.native
    location = element.location
    size = element.size
    temp_screenshot = Image.read('temp.png').first
    expected_img = Image.read(expected).first
    element_img = temp_screenshot.crop(location.x, location.y, size.width, size.height)    
    raise "The design reference #{expected} does not exist" unless File.exists? "google_logo.png"
    diff_metric = element_img.compare_channel(expected_img,MeanAbsoluteErrorMetric)
    diff_metric[1] == 0.0
  end
end


describe "Google search" do
  it "blah" do
   visit('/')
   page.find(:css, '#hplogo').should look_like('google_logo.png')
  end
end



