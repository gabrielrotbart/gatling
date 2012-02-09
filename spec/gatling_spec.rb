require 'spec_helper'
include Capybara::DSL


describe 'gatling' do


  before(:all) do

    include Rack::Test::Methods

    def app
      @app ||= Sinatra::Application
    end

    #expected image to compare with
    @example_good_image = 'smiley-faceicon.png'

    @spec_support_root = spec_support_root
  end



  after(:each) do
    remove_refs(@ref_path)
  end


  describe 'creating an initial reference (expected) image' do

    before(:each) do
      @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
    end

      it "should notify that no reference exists for image and create a candidate" do
        gatling = gatling_for_spec('smiley-faceicon.png')
        expect {gatling.matches?}.should raise_error(RuntimeError, "The design reference #{@example_good_image} does not exist, #{@ref_path}/candidate/#{@example_good_image} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference")
        File.exists?(File.join(@ref_path,'candidate','smiley-faceicon.png')).should be_true
      end
    end

  describe 'image comparison' do

   before(:each) do
     @ready_ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ready_candidate_ref')
     @gatling = gatling_for_spec('smiley-faceicon.png')
   end

    it 'captured and referenced images match' do
      @gatling.matches?.should be_true
    end

    # it 'captured and referenced images do NOT match' do
    #       @gatling_bad_example = Gatling::Comparison.new('smiley-bad.png', @element)
    #       expect {@gatling_bad_example.matches}.should be_true
    #     end

  end

  # MOCK SELENIUM ELEMENT
  # correct size (340px*42px)
  # image magick saves screenshot
  #create diff creates the correct candidate

  describe 'training mode populates a candidate reference' do  #

    before(:each) do
      @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')

      visit('/')
      element = page.find(:css, "#smiley")
      @trainer = Gatling::Trainer.new(element, 'smiley-faceicon.png')
    end

    it 'should create a reference from a candidate' do
      @trainer.run
      File.exists?(File.join(@ref_path,'smiley-faceicon.png')).should be_true
    end

  end

end

