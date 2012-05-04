require 'spec_helper'

describe Gatling::Image do

  before :all do
    @ref_path = './image_tests'
    Gatling::Configuration.reference_image_path = @ref_path
    @expected_temp_path = File.join @ref_path, 'temp'
    @expected_temp_image_path = File.join @expected_temp_path, 'image.png'
  end

  describe 'should initialize from' do

    it 'image file type' do
      File.stub(:exists?).and_return true
      image_mock = mock(Magick::Image)
      Magick::Image.should_receive(:read).with('./image_tests/image.png').and_return([image_mock])

      subject = Gatling::ImageFromFile.new("image.png")
      subject.image.should == image_mock
      subject.file_name.should == 'image.png'
    end

    it 'web element type' do
      mock_element = mock(Capybara::Node::Element)
      mock_capture_element = mock(Gatling::CaptureElement)
      mock_image = mock(Magick::Image)

      Gatling::CaptureElement.should_receive(:new).and_return mock_capture_element
      mock_capture_element.should_receive(:capture).and_return mock_image
      subject = Gatling::ImageFromElement.new(mock_element, "image.png")
      subject.image.should == mock_image
      subject.file_name.should == 'image.png'
    end

    it 'diff image' do
      mock_image = mock(Magick::Image)
      subject = Gatling::Image.new(mock_image, 'image.png')
      subject.image.should == mock_image
      subject.file_name.should == 'image.png'
    end
  end

  describe "Images file handling" do


    it 'will save an image to the correct path for the type' do
      mock_image = mock(Magick::Image)
      mock_image.should_receive(:write).with('./image_tests/temp/image.png').and_return()
      subject = Gatling::Image.new(mock_image, 'image.png')
      subject.image = mock_image
      subject.file_name = 'image.png'
      subject.save(:as => :temp)
    end

    it 'will create directory, then save and image if directory doesnt exist' do

      mock_image = stub(Magick::Image)
      mock_image.should_receive(:write).with(@expected_temp_image_path).and_return()

      File.should_receive(:exists?).with(@expected_temp_path).and_return(false)
      FileUtils.should_receive(:mkdir_p).with(@expected_temp_path)
      subject = Gatling::Image.new(mock_image, 'image.png')

      subject.save(:as => :temp)
      subject.path.should == @expected_temp_path
    end

    it 'will save and image if directory exists' do
      mock_image = stub(Magick::Image)
      mock_image.should_receive(:write).with(@expected_temp_image_path).and_return()

      File.should_receive(:exists?).with(@expected_temp_path).and_return(true)
      FileUtils.should_not_receive(:mkdir_p)
      subject = Gatling::Image.new(mock_image, 'image.png')

      subject.save(:as => :temp)
      subject.path.should == @expected_temp_path
    end

    it 'should check if a file exists, with the file name and type' do
      mock_image = mock(Magick::Image)
      File.should_receive(:exists?).with './image_tests/image.png'
      subject = Gatling::Image.new(mock_image, 'image.png')
      subject.file_name = 'image.png'
      subject.exists?
    end

    it 'image object should default to reference type' do
      mock_image = mock(Magick::Image)
      subject = Gatling::Image.new(mock_image, 'image.png')
      subject.path.should == @ref_path
    end
  end


end

describe Gatling::ImageFromElement