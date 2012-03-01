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
    
    @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
  end


  after(:each) do
    remove_refs(@ref_path)
  end
  
  it 'should initialize and run gatling' do
    save_element_for_test
    
    visit('/')
    @element = page.find(:css, "#smiley")
    @element.should look_like('smiley-faceicon.png')
  end

  # it 'should exclude a specified child css element' do
  #   save_element_for_test
    
  #   visit('/')
  #   @element = page.find(:css, "#smiley")
  #   @element.should look_like('smiley-faceicon.png', :exclude => '#changable').should be_true
  # end

  
  it 'should initialize and run training mode when GATLING_TRAINER is toggled' do
    ENV['GATLING_TRAINER'] = 'true'
   
    visit('/')
    @element = page.find(:css, "#smiley")
    @element.should look_like('smiley-faceicon.png')
    File.exists?(File.join(@ref_path,'smiley-faceicon.png')).should be_true
  end
  
end