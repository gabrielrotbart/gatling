require 'spec_helper'
include Capybara::DSL

describe Gatling do

  before :all do
    @spec_support_root = spec_support_root
    @black_box = 'black.png'
    @red_box = 'red.png'
    @ref_path = Gatling::Configuration.reference_image_path = './ref_path'
  end

  after :each  do
    Gatling::Configuration.trainer_toggle = false
  end

  describe 'Gatling' do

    it 'will return true if the images are identical' do
      expected_path = File.join  @ref_path, @black_box

      mock_element = mock
      mock_element.stub(:native).and_return mock_element

      image_mock = mock(Magick::Image)
      Magick::Image.should_receive(:read).with(expected_path).and_return([image_mock])

      File.should_receive(:exists?).with(expected_path).and_return(true)

      mock_comparision = mock
      mock_comparision.stub(:match).and_return true
      Gatling::Comparison.should_receive(:new).and_return(mock_comparision)

      mock_capture_element = mock
      mock_capture_element.should_receive(:capture).and_return(@black_box)
      Gatling::CaptureElement.should_receive(:new).and_return(mock_capture_element)

      Gatling.matches?(@black_box, mock_element).should(be_true)
    end
  end
end