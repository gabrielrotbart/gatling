require 'spec_helper'

describe "Gatling::Configuration" do

  describe "#reference_image_path" do
    before :each do
      Gatling::Configuration.reference_image_path = nil
    end 

    describe "Without Rails" do
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
        Gatling::Configuration.reference_image_path = "my custom path"
        Gatling::Configuration.reference_image_path.should eql("my custom path")
      end

    end
  end  

  describe '#trainer_toggle' do

    it 'should default to false' do
      Gatling::Configuration.trainer_toggle.should eql(false)
    end

    it 'can be toggled to true' do
      Gatling::Configuration.trainer_toggle = true
      Gatling::Configuration.trainer_toggle.should eql(true)
    end

    it 'toggeled using GATLING_TRAINER = false' do
      ENV['GATLING_TRAINER'] = 'false'
      Gatling::Configuration.trainer_toggle.should eql(false)
    end

    it 'toggeled using GATLING_TRAINER = true' do
      ENV['GATLING_TRAINER'] = 'true'
      Gatling::Configuration.trainer_toggle.should eql(true)
    end

    it 'toggeled using GATLING_TRAINER = nil' do
      ENV['GATLING_TRAINER'] = nil
      Gatling::Configuration.trainer_toggle.should eql(false)
    end

    after(:each) do
      Gatling::Configuration.trainer_toggle = false
      ENV['GATLING_TRAINER'] = nil
    end

  end

end