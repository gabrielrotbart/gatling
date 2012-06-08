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


  class Point
    attr_accessor :x, :y
  end

  class Size
    attr_accessor :width, :height
  end

  it 'should get the position of the css element' do

    #Overiding the stupid public method:y of YAML module

    location = Point.new
    location.x = 1
    location.y = 2

    size = Size.new
    size.width = 100
    size.height = 200

    mock_element = mock
    mock_element.stub(:native).and_return(mock_element)
    mock_element.stub(:location).and_return(location)
    mock_element.stub(:size).and_return(size)

    position = @capture_element.get_element_position mock_element

    position[:x].should eql(1)
    position[:y].should eql(2)
    position[:width].should eql(100)
    position[:height].should eql(200)
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

