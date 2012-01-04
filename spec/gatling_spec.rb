require 'spec_helper'
include Capybara::DSL

describe 'gatling' do
  before(:all) do
    
    include Rack::Test::Methods

    def app
      @app ||= Sinatra::Application
    end
          
    @ref_path = Gatling::Configuration.reference_image_path = "ref_path"
        
    #expected image to compare with 
    @example_image = 'smiley-faceicon.png'
    @example_image_path = @ref_path + '/smiley-faceicon.png'
    

        
  end
      
  before(:each) do
    # creating an element to compare
    visit('/')
    @element = page.find(:css, "#smiley")
    
    @gatling_example = Gatling::Comparison.new(@example_image, @element)
  end   
      
  after(:each) do
    remove_refs('ref_path')
  end
  
  
  describe 'creating an initial reference (expected) image' do    
    
    it "should notify that no reference exists for image and create a candidate" do
      expect {@gatling_example.matches?}.should raise_error(RuntimeError, "The design reference #{@example_image} does not exist, ref_path/candidate/#{@example_image} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference")
      File.exists?(File.join(@ref_path,'candidate','smiley-faceicon.png')).should be_true
    end    
  end
  
  describe 'image comparison' do
  
   before(:each) do
     expect {@gatling_example.matches?}.should raise_error
     FileUtils.cp(File.join(@ref_path,'candidate','smiley-faceicon.png'),File.join(@ref_path,'smiley-faceicon.png'))
   end
   
    it 'captured and referenced images match' do 
      File.exists?(File.join(@ref_path,'smiley-faceicon.png')).should be_true
      expect {gatling.matches?}.should be_true
    end
  
    it 'captured and referenced images do NOT match' do
      pending
    end
    
  end  
  
end

