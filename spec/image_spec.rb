require 'spec_helper'

describe Gatling::Image do

  before :all do
    ref_path = './image_tests'
    Gatling::Configuration.reference_image_path = ref_path
    @expected_path = File.join ref_path, 'temp'
    @expected_full_path = File.join @expected_path, 'image.png'
    Gatling.reference_file_name = 'image.png'
  end

  describe 'should initialize from' do

    it 'image file type' do
      File.stub(:exists?).and_return true
      image_mock = mock(Magick::Image)
      Magick::Image.should_receive(:read).with('./image_tests/image.png').and_return([image_mock])

      subject = Gatling::Image.new(:from_file)
      subject.image.should == image_mock
      subject.file_name.should == 'image.png'
    end

    it 'web element type' do
      mock_element = mock(Capybara::Node::Element)
      mock_capture_element = mock(Gatling::CaptureElement)
      mock_image = mock(Magick::Image)

      Gatling::CaptureElement.should_receive(:new).and_return mock_capture_element
      mock_capture_element.should_receive(:capture).and_return mock_image
      subject = Gatling::Image.new(:from_element, mock_element)
      subject.image.should == mock_image
      subject.file_name.should == 'image.png'
    end

    it 'diff image' do
      mock_image = mock(Magick::Image)
      subject = Gatling::Image.new(:from_diff, mock_image)
      subject.image.should == mock_image
      subject.file_name.should == 'image.png'
    end
  end

  describe "Images file handling" do

    before :each do

    end

    it 'will save an image to the correct path for the type' do
      mock_image = mock(Magick::Image)
      mock_image.should_receive(:write).with('./image_tests/temp/image.png').and_return()
      subject = Gatling::Image.new(:from_diff, mock_image)
      subject.image = mock_image
      subject.file_name = 'image.png'
      subject.save(:as => :temp)
    end

    it 'will create directory, then save and image if directory doesnt exist' do
      image_path = 'path/to/image/in/sub/directory/image.png'
      expected_full_path = File.join(Gatling::Configuration.path(:temp), image_path)
      expected_image_dir = File.dirname(expected_full_path)

      mock_image = stub(Magick::Image)
      mock_image.should_receive(:write).with(expected_full_path).and_return()

      File.should_receive(:exists?).with(expected_full_path).and_return(false)
      FileUtils.should_receive(:mkdir_p).with(expected_image_dir)
      subject = Gatling::Image.new(:from_diff, mock_image, image_path)

      subject.save(:as => :temp)
      subject.path.should == expected_full_path
    end

    it 'will save an image if directory exist' do
      mock_image = stub(Magick::Image)
      mock_image.should_receive(:write).with(@expected_full_path).and_return()

      File.should_receive(:exists?).with(@expected_full_path).and_return(true)
      FileUtils.should_not_receive(:mkdir_p)
      subject = Gatling::Image.new(:from_diff, mock_image)

      subject.save(:as => :temp)
      subject.path.should == @expected_full_path
    end

    it 'should check if a file exists, with the file name and type' do
      mock_image = mock(Magick::Image)
      File.should_receive(:exists?).with './image_tests/image.png'
      subject = Gatling::Image.new(:from_diff, mock_image)
      subject.file_name = 'image.png'
      subject.exists?
    end
  end
end

