require 'spec_helper'

describe Gatling::Image do

  before :all do
    Gatling::Configuration.reference_image_path = './image_tests'
  end

  describe 'should initialize from' do

    it 'image file type' do
        File.stub(:exists?).and_return true
        image_mock = mock(Magick::Image)
        Magick::Image.should_receive(:read).with('./image_tests/image.png').and_return([image_mock])

        subject = Gatling::Image.new(:from_file, 'image.png')
        subject.image.should == image_mock
        subject.file_name.should == 'image.png'
    end

    it 'web element type' do
      pending
    end
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
    image_mock.should_receive(:write).with('./image_tests/temp/image.png').and_return()

    subject.rmagick_image = image_mock
    subject.file_name = 'image.png'
    subject.save(:as => :temp)
    subject.path.should == './image_tests/temp/image.png'
  end

  it 'should check if a file exists, with the file name and type' do
    File.should_receive(:exists?).with './image_tests/image.png'
    subject.file_name = 'image.png'
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
