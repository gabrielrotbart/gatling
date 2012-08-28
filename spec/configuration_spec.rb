require 'spec_helper'

describe Gatling::Configuration do


  describe "#reference_image_path" do

    after :each do
      config_clean_up
    end

    describe "without Rails" do
      it "should default to './spec/reference_images' when not in a rails environment" do
        Gatling::Configuration.reference_image_path.should eql("spec/reference_images")
      end
    end

    describe "with rails" do

      before do
        begin
          # Check that rails exists, otherwise fake it for the test
          Module.const_get("Rails")
        rescue NameError
          module Rails
            def self.root
              "fake_rails_root"
            end
          end
        end
      end

      it "should default to <Rails.root>/spec/reference_images in a rails environment" do
        subject.reference_image_path.should  == "fake_rails_root/spec/reference_images"
      end

      it "should be overrideable in a rails environment" do
        subject.reference_image_path = "my custom path"
        subject.reference_image_path.should == "my custom path"
      end

      it 'should return the directory for a type of image' do
        subject.reference_image_path = "a_path"
        subject.path(:temp).should == 'a_path/temp'
      end

      it 'should thrown an error when you ask for the path of an unknown image type' do
        expect {subject.path(:unknown)}.to raise_error "Unknown image type 'unknown'"
      end

    end

    describe "creating custom reference folders" do

      before :each do
        subject.reference_image_path = '/some/ref/path'
      end

      it "should default to custom folders off" do
        subject.browser_folders.should == false
      end

      it "should allow setting custom folders on" do
        subject.browser_folders = true
        subject.browser_folders.should == true
      end


      it "should set reference_image_path to default when browser can\'t be found" do
        subject.browser_folders = true
        Capybara.page.driver.browser.should_receive(:browser).at_least(:once).and_raise(StandardError.new)
        subject.reference_image_path.should == '/some/ref/path'
      end

      it "should create custom folder for each browser according to ENV" do
        pending
      end

      it "should set the image reference path for each browser according to selenium driver if no ENV is set" do
        subject.browser_folders = true
        subject.stub!(:browser).and_return('chrome')
        subject.reference_image_path.should == '/some/ref/path/chrome'
        subject.browser_folders = false
      end


    end
  end

  describe "#max_no_tries" do

      it "should default to 5" do
        subject.max_no_tries.should == 5
      end

      it "should be settable" do
        Gatling::Configuration.max_no_tries = 1
        subject.max_no_tries.should == 1
      end
  end

  describe "#sleep_between_tries" do

    it "should default to 0.5" do
      subject.sleep_between_tries.should == 0.5
    end

    it "should be settable" do
      subject.sleep_between_tries = 55
      subject.sleep_between_tries.should == 55
    end
  end

  describe "settings" do

    describe "should accept a block of settings and parse them correctly" do

      it "for reference_image_path" do
        Gatling.config do |c|
          c.reference_image_path = 'custom_path'
        end
        subject.reference_image_path.should == 'custom_path'
      end

      it "for max_no_tries" do
        Gatling.config do |c|
          c.max_no_tries = 3
        end

        subject.max_no_tries.should == 3
      end

      it "sleep_between_tries" do
        Gatling.config do |c|
          c.sleep_between_tries = 0.7
        end
        subject.sleep_between_tries.should == 0.7
      end

     it "for browser_folders" do
        Gatling.config do |c|
          c.browser_folders = true
        end

        subject.browser_folders.should == true
      end

    end
  end

  describe "config block" do

    it 'should be able to set a config block' do
      Gatling.config do |c|
        c.reference_image_path = 'some/path'
        c.max_no_tries = '4'
        c.sleep_between_tries = '5'
        c.browser_folders = false
      end

      subject.reference_image_path.should == 'some/path'
      subject.max_no_tries.should == '4'
      subject.sleep_between_tries.should == '5'
      subject.browser_folders.should == false
    end 

    it 'should raise depreciation alert when calling old block' do
      expect {
        Gatling.config do |c|
          Gatling.reference_image_path = 'some/path'
          Gatling.max_no_tries = '4'
          Gatling.sleep_between_tries = '5'
          Gatling.browser_folders = false
      end
      }.to raise_error "Config block has changed. Example: Gatling.config {|c| c.reference_image_path = 'some/path'}. Please see README"
    end

   
  end




end