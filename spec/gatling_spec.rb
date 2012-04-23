require 'spec_helper'
include Capybara::DSL

describe Gatling do

  before :all do
    @spec_support_root = spec_support_root
    @box = 'box'
    @black_box = 'black.png'
    @red_box = 'red.png'
    @ref_path = Gatling::Configuration.reference_image_path = './ref_path'
  end

  after :each  do
    Gatling::Configuration.trainer_toggle = false
  end

  describe '#Gatling' do

    before :each do
      @image_class_mock = mock(Gatling::Image)
    end

    it 'will return true if the images are identical' do
      pending
    end

    it "#save_image_as_diff" do
      @image_class_mock.should_receive(:save).with(:as => :diff).and_return(@ref_path)
      @image_class_mock.should_receive(:file_name).at_least(:once).and_return("some_name")
      expect {subject.save_image_as_diff(@image_class_mock)}.should raise_error
    end

    it "#save_image_as_candidate" do
      @image_class_mock.should_receive(:save).with(:as => :candidate).and_return(@ref_path)
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
        @image_class_mock.should_receive(:save).with(:as => :reference).and_return(@ref_path)
        @image_class_mock.should_receive(:path).and_return(@path)
        subject.save_image_as_reference(@image_class_mock)
      end

    end

    describe "#try_until_match" do

      before :each do
        pending
      end

      it "should try match for a specified amount of times" do
        pending
      end

      it "should pass after a few tries if match is found" do
        pending
      end

    end

  end
end