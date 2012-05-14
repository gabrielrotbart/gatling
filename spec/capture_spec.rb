require 'spec_helper'

describe Gatling::CaptureElement do

  before :each do
    capybara_node = mock (Capybara::Node::Element)
    Gatling::Configuration.should_receive(:reference_image_path).and_return("./")
    @capture_element = Gatling::CaptureElement.new capybara_node, capybara_node
  end

  after :each do
    config_clean_up
  end

  describe 'take_screenshot' do
    before do
      @webdriver = double('webdriver')
      Capybara.stub_chain(:page, :driver, :browser).and_return(@webdriver)

      @expected_temp_screenshot_file_pattern = /.*\/temp\/temp-\d+.png/
    end

    it 'should create temp directory when it does not exist' do
      @webdriver.stub!(:save_screenshot)
      Magick::Image.stub!(:read).and_return([])

      File.stub!(:'exists?').and_return(false)
      FileUtils.should_receive(:mkdir_p).with('./temp')

      @capture_element.take_screenshot
    end


    it 'should work when Gatling is called concurrently from multiple processes' do
      @webdriver.should_receive(:save_screenshot).with(@expected_temp_screenshot_file_pattern)
      Magick::Image.should_receive(:read).with(@expected_temp_screenshot_file_pattern).and_return([])

      @capture_element.take_screenshot
    end
  end



  # it 'should exclude a specified element from capture' do
  #  element_to_capture =

  #  element_to_exclude = 'womething.child'
  # # @cropped_and_censored_element = (element_to_capture, element_to_exclude).exclude
  #  @cropped_and_censored_element.should_not equal(@element_to_capture)
  #  @cropped_and_censored_element.should_not equal(@element_to_exclude)
  # end

end

