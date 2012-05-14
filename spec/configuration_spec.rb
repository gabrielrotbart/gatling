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
        Gatling::Configuration.reference_image_path.should eql("fake_rails_root/spec/reference_images")
      end

      it "should be overrideable in a rails environment" do
        subject.reference_image_path = "my custom path"
        Gatling::Configuration.reference_image_path.should eql("my custom path")
      end

      it 'should return the directory for a type of image' do
        Gatling::Configuration.reference_image_path = "a_path"
        subject.path(:temp).should == 'a_path/temp'
      end

      it 'should thrown an error when you ask for the path of an unknown image type' do
        expect { Gatling::Configuration.path(:unknown)}.should raise_error "Unkown image type 'unknown'"
      end

    end

    describe "creating custom reference folders" do

      before :each do
        Gatling.reference_image_path = '/some/ref/path'
      end

      it "should default to custom folders off" do
        subject.browser_folders.should == false
      end

      it "should allow setting custom folders on" do
        Gatling::Configuration.browser_folders = true
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

  describe '#trainer_toggle' do

    it 'should default to false' do
      subject.trainer_toggle.should eql(false)
    end

    it 'can be toggled to true' do
      Gatling::Configuration.trainer_toggle = true
      subject.trainer_toggle.should eql(true)
    end

    it 'toggeled using GATLING_TRAINER = false' do
      ENV['GATLING_TRAINER'] = 'false'
      subject.trainer_toggle.should eql(false)
    end

    it 'toggeled using GATLING_TRAINER = true' do
      ENV['GATLING_TRAINER'] = 'true'
      subject.trainer_toggle.should eql(true)
    end

    it 'toggeled using GATLING_TRAINER = nil' do
      ENV['GATLING_TRAINER'] = nil
      subject.trainer_toggle.should eql(false)
    end

    after(:each) do
      Gatling::Configuration.trainer_toggle = false
      ENV['GATLING_TRAINER'] = nil
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
      Gatling::Configuration.sleep_between_tries = 55
      subject.sleep_between_tries.should eql 55
    end
  end

  describe "settings" do

    describe "should accept a block of settings and parse them correctly" do

      it "for reference_image_path" do
        Gatling.config do |setting|
          Gatling.reference_image_path = 'custom_path'
        end
        subject.reference_image_path.should eql 'custom_path'
      end

      it "for max_no_tries" do
        Gatling.config do |setting|
          Gatling.max_no_tries = 3
        end
        subject.max_no_tries.should eql 3
      end

      it "sleep_between_tries" do
        Gatling.config do |setting|
          Gatling.sleep_between_tries = 0.7
        end
        subject.sleep_between_tries.should eql 0.7
      end

      it "browser_folders" do
        Gatling.config do |setting|
          Gatling.browser_folders = true
        end
        subject.browser_folders.should eql true
      end

    end
  end




end