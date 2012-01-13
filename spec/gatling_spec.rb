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
    @example_good_image = 'smiley-faceicon.png'    

        
  end
      
  before(:each) do
    # creating an element to compare
    visit('/')
    @element = page.find(:css, "#smiley")
    
    @gatling_good_example = Gatling::Comparison.new('smiley-faceicon.png', @element)
    @gatling_bad_example = Gatling::Comparison.new('smiley-faceicon.png', @element)
  end   
      
  after(:each) do
    remove_refs('ref_path')
  end
  
  
  describe 'creating an initial reference (expected) image' do    
    
    it "should notify that no reference exists for image and create a candidate" do
      expect {@gatling_good_example.matches?}.should raise_error(RuntimeError, "The design reference #{@example_good_image} does not exist, ref_path/candidate/#{@example_good_image} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference")
      File.exists?(File.join(@ref_path,'candidate','smiley-faceicon.png')).should be_true
    end    
  end
  
  describe 'image comparison' do
  
   before(:each) do
    begin
      @gatling_good_example.matches?
    rescue RuntimeError
       FileUtils.cp(File.join(@ref_path,'candidate','smiley-faceicon.png'),File.join('smiley-faceicon.png'))
    end   
   end
   
    it 'captured and referenced images match' do 
      expect {gatling.matches?}.should be_true
    end
  
    # it 'captured and referenced images do NOT match' do
    #       @gatling_bad_example = Gatling::Comparison.new('smiley-bad.png', @element)
    #       expect {@gatling_bad_example.matches}.should be_true
    #     end
    
  end  
  
  # MOCK SELENIUM ELEMENT
  # correct size
  # image magick saves screenshot
  #create diff creates the correct candidate
  
end

