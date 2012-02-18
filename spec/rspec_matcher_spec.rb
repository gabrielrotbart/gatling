require 'spec_helper'
include Capybara::DSL


describe 'rspec matcher' do
  
  before(:all) do

    include Rack::Test::Methods

    def app
      Sinatra::Application
    end

    #expected image to compare with
    @example_good_image = 'smiley-faceicon.png'

    @spec_support_root = spec_support_root
  end


  after(:each) do
    remove_refs(@ref_path)
  end
  
  it "should initialize and run gatling" do

    @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
    save_element_for_test
    
    visit('/')
    @element = page.find(:css, "#smiley")
    @element.should look_like('smiley-faceicon.png')
  end
  
end