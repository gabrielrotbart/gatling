require 'spec_helper'
include Capybara::DSL

describe 'gatling' do
  # before(:all) do
  #     Gatling::Configuration.reference_image_path = "ref_path"
  #     @expected_image = 'smiley.png'
  #     filepath = File.join('support','smiley_site.html')
  #   puts filepath
  #     @page_to_capture = "/"
  #     puts @page_to_capture
  #   end
  
  
  describe 'creating an initial reference (expected) image' do
    
    include Rack::Test::Methods
        
            def app
                @app ||= Sinatra::Application
            end
    
    it "should notify that no reference exists for image" do
      visit('/')
      sleep(60)
    end

    it "should create reference candidate in the candidate folder" do
     pending
    end
  end
  
  describe 'captured and referenced images match' do
    pending
  end
  
  describe 'captured and referenced images do NOT match' do
    pending
  end
end
  
  
  

