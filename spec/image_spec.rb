require 'spec_helper'

describe Gatling::Image do

  let(:example_image)           { Magick::Image.new(1,1) }
  let(:ref_path)                { 'spec/reference_images/image.png' }

  # before :all do
  #   Gatling::Configuration.reference_image_path = 'spec/reference_images'
  # end

  after :each do
    config_clean_up
  end

  describe 'should initialize from' do
    it 'ImageFromFile - IO file read' do
      File.stub(:exists?).and_return(true)
      Magick::Image.should_receive(:read).with(ref_path).and_return([example_image])
      
      subject = Gatling::ImageFromFile.new("image.png")
      subject.image.should == example_image
      subject.file_name.should == 'image.png'
    end

    it 'web element type' do
      mock_element = mock(Capybara::Node::Element)
      Gatling::CaptureElement.should_receive(:capture).with(mock_element).and_return(example_image)

      subject = Gatling::ImageFromElement.new(mock_element, "image.png")
      subject.image.class.should == example_image.class
      subject.file_name.should == 'image.png'
    end
  end

  describe "save" do
    it 'will save an image' do
      example_image.should_receive(:write).with(ref_path).and_return()

      File.should_receive(:exists?).with(ref_path).and_return(true)
      FileUtils.should_not_receive(:mkdir_p)
      subject = Gatling::Image.new(example_image, "image.png")

      subject.save
      subject.path.should == ref_path
    end
  end

  describe "it creates a path from path types" do

    before :each do
      Gatling::Configuration.should_receive(:reference_image_path).any_number_of_times.and_return('/some/path')
      mock_image = mock(Magick::Image)
      @subject = Gatling::Image.new(mock_image, 'image.png')
    end

    it "from reference" do
      # expected_path = '/some/path/reference'
      @subject.path.should == '/some/path/image.png'
    end

    it "from diff" do
      @subject.path(:diff).should == '/some/path/diff/image.png'
    end

    it "from candidate" do
      @subject.path(:candidate).should == '/some/path/candidate/image.png'
    end

  end

end