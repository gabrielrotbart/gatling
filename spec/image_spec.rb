require 'spec_helper'

describe Gatling::Image do

  before :all do
    Gatling::Configuration.reference_image_path = './image_tests' 
  end

  it 'should base itself on a file' do
    File.stub(:exists?).and_return true
    image_mock = mock(Magick::Image)
    Magick::Image.should_receive(:read).with('./image_tests/image.png').and_return([image_mock])
    
    subject.base_on_file('image.png')
    subject.rmagick_image.should == image_mock
    subject.file_name.should == 'image.png'
  end

  it 'should save an image to the path for the type' do
    image_mock = mock(Magick::Image)
    image_mock.should_receive(:write).with('./image_tests/temp/image_file_name.png').and_return()

    subject.rmagick_image = image_mock
    subject.file_name = 'image_file_name.png'
    subject.save(:as => :temp)
  end

  it 'should check if a file exists, with the file name and type' do
    File.should_receive(:exists?).with './image_tests/image_file_name.png'
    subject.file_name = 'image_file_name.png'
    subject.exists?
  end

  it 'should base itself on a web element' do
    mock_element = mock(Capybara::Node::Element)
    mock_capture_element = mock(Gatling::CaptureElement)
    Gatling::CaptureElement.should_receive(:new).and_return mock_capture_element
    mock_capture_element.should_receive(:capture)
    subject.base_on_element(mock_element)
  end

end
