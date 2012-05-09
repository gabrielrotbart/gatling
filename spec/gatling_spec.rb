require 'spec_helper'
include Capybara::DSL

describe Gatling do

  before :all do
    @spec_support_root = spec_support_root
    @box = 'box'
    @black_box = 'black.png'
    @red_box = 'red.png'
    @ref_path = Gatling::Configuration.reference_image_path = './ref_path'
    Gatling.browser_ref_paths_toggle = false
  end

  after :each  do
    Gatling::Configuration.trainer_toggle = false
  end

  describe '#Gatling' do

    before :each do
      @image_class_mock = mock(Gatling::Image)
    end

    it 'will return true if the images are identical' do
        @apple = mock("Gatling::Image")
        @orange = mock("Gatling::Image")
        @element  = mock("Gatling::CaptureElement")
        @comparison = mock("Gatling::Comparison")
        Gatling::ImageFromFile.stub!(:new).and_return(@orange)
        Gatling::ImageFromElement.stub!(:new).and_return(@orange)
        Gatling::Comparison.stub!(:new).and_return(@comparison)
        @comparison.stub!(:matches?).and_return(true)
        File.stub!(:exists?).and_return(true)
        subject.matches?("orange.png", @element).should be_true
    end

    it "#save_image_as_diff" do
      @image_class_mock.should_receive(:save).with(:diff).and_return(@ref_path)
      @image_class_mock.should_receive(:save).with(:candidate).and_return(@ref_path)
      @image_class_mock.should_receive(:file_name).at_least(:once).and_return("some_name")
      expect {subject.save_image_as_diff(@image_class_mock)}.should raise_error
    end

    it "#save_image_as_candidate" do
      @image_class_mock.should_receive(:save).with(:candidate).and_return(@ref_path)
      @image_class_mock.should_receive(:file_name).at_least(:once).and_return("some_name")
      @image_class_mock.should_receive(:path).and_return(@path)
      expect {subject.save_image_as_candidate(@image_class_mock)}.should raise_error
    end

    describe "#save_image_as_reference" do

      it "when image.exists? == true" do
        @image_class_mock.should_receive(:exists?).and_return(true)
        @image_class_mock.should_receive(:path).and_return(@path)
        @image_class_mock.should_not_receive(:save)
        subject.save_image_as_reference(@image_class_mock)
      end

      it "when image_exists? == false" do
        @image_class_mock.should_receive(:exists?).and_return(false)
        @image_class_mock.should_receive(:save).with(:reference).and_return(@ref_path)
        @image_class_mock.should_receive(:path).and_return(@path)
        subject.save_image_as_reference(@image_class_mock)
      end

    end



    end

describe "#compare_until_match" do

      before do
        @apple = mock("Gatling::Image")
        @orange = mock("Gatling::Image")
        @element  = mock(Gatling::CaptureElement)
        @comparison = mock("Gatling::Comparison")
        Gatling::ImageFromFile.stub!(:new).and_return(@orange)
        Gatling::ImageFromElement.stub!(:new).and_return(@orange)
        Gatling::Comparison.stub!(:new).and_return(@comparison)
      end

      it "should try match for a specified amount of times" do
        @comparison.should_receive(:matches?).exactly(3).times
        Gatling.compare_until_match(@element, "orange.png", 3)
      end

      it "should pass after a few tries if match is found" do
        @comparison.should_receive(:matches?).exactly(1).times.and_return(true)
        Gatling.compare_until_match(@element, "orange.png", 3)
      end
  end
end