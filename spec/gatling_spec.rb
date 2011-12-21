require 'spec_helper'
include Capybara::DSL

describe 'gatling' do
  before(:all) do
      Gatling::Configuration.reference_image_path = "ref_path"
      @expected_image = 'google_search_button.png'
      @page_to_capture = 'http://www.google.com'
      compare = Gatling::Comparison.new()
    end
  
  
  describe 'creating an initial reference (expected) image' do
    it "should notify that no reference exists for image" do
      visit(@page_to_capture)
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
  
  
  

