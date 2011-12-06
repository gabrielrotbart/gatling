require 'spec_helper'

describe "Gatling::Configuration" do

  describe "#reference_image_path" do

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

    it "should default to <Rails.root>/spec/reference_images" do
      Gatling::Configuration.reference_image_path.should eql("fake_rails_root/spec/reference_images")
    end

    it "should be overrideable" do 
      Gatling::Configuration.reference_image_path = "my custom path"
      Gatling::Configuration.reference_image_path.should eql("my custom path")
    end
    
  end

end