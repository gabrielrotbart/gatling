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
      mock_element = mock(Capybara::Node::Element)
      mock_capture_element = mock(Gatling::CaptureElement)
      mock_image = mock(Magick::Image)

      Gatling::CaptureElement.should_receive(:new).and_return mock_capture_element
      mock_capture_element.should_receive(:capture).and_return mock_image
      subject = Gatling::Image.new(:from_element, 'image.png', mock_element)
      subject.image.should == mock_image
      subject.file_name.should == 'image.png'
    end

    it 'diff image' do
       mock_image = mock(Magick::Image)
       subject = Gatling::Image.new(:from_diff, 'image.png', mock_image)
       subject.image.should == mock_image
       subject.file_name.should == 'image.png'
    end
  end

  it 'should be ok with nil' do
    pending
  end

  it 'should save an image to the path for the type' do
    mock_image = mock(Magick::Image)
    mock_image.should_receive(:write).with('./image_tests/temp/image.png').and_return()
    subject = Gatling::Image.new(:from_diff, 'image.png', mock_image)
    subject.image = mock_image
    subject.file_name = 'image.png'
    subject.save(:as => :temp)
    subject.path.should == './image_tests/temp/image.png'
  end

  it 'should check if a file exists, with the file name and type' do
    mock_image = mock(Magick::Image)
    File.should_receive(:exists?).with './image_tests/image.png'
    subject = Gatling::Image.new(:from_diff, 'image.png', mock_image)
    subject.file_name = 'image.png'
    subject.exists?
  end
end
