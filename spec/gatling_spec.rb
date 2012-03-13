require 'spec_helper'
include Capybara::DSL


describe 'Gatling' do


  before(:all) do

    # include Rack::Test::Methods
    #
    #     def app
    #       Sinatra::Application
    #     end

    #expected image to compare with
    @example_good_image = 'orange.png'
    @spec_support_root = spec_support_root
    create_reference_for_tests(File.join('spec','support','assets'))
  end

  after(:each) do
    remove_refs(@ref_path)
  end

  describe 'creating an initial reference (expected) image' do

    before(:each) do
      @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
    end

    it "should notify that no reference exists for image and create a candidate" do
      element = element_for_spec

      expect {Gatling.matches?('orange.png', element)}.should raise_error(RuntimeError, "The design reference #{@example_good_image} does not exist, #{@ref_path}/candidate/#{@example_good_image} is now available to be used as a reference. Copy candidate to root reference_image_path to use as reference")
      File.exists?(File.join(@ref_path,'candidate',@example_good_image)).should be_true
    end
  end

  describe 'image comparison' do

    before(:each) do
      # @ready_ref = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ready_candidate_ref')
      @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
      create_reference_for_tests(@ref_path)
    end

    it 'images match' do
     element = element_for_spec

     Gatling.matches?('orange.png', element).should be_true
    end

    it 'creates a diff images and saves it if the images are different' do
       #convert -fill none -stroke black -strokewidth 5 orange.png -draw 'arc 155,25 185,45 180' sad-faceicon.png
       convert_element_to_bad_element(File.join(@ref_path,"#{@example_good_image}"))
       gatling = gatling_for_spec('orange.png')
       expect {gatling.matches?}.should raise_error(RuntimeError, "element did not match #{@example_good_image}. A diff image: orange.png was created in #{@ref_path}/diff/orange.png. A new reference #{@ref_path}/candidate/#{@example_good_image} can be used to fix the test")
       File.exists?(File.join(@ref_path,'diff','orange.png')).should be_true
    end
  end

   # describe 'exclude element from comparison' do
   #
   #    before do
   #      @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
   #      @gatling = gatling_for_spec('orange.png')
   #      create_reference_for_tests(@ref_path)
   #    end
   #
   #    it 'should black out an element from the cropped screenshot' do
   #      pending
   #    end
   #  end

  describe 'trainer toggle' do

    before(:each) do
      @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
    end

    it 'should save a reference file to the nominated folder without raising an exception' do
      Gatling::Configuration.trainer_toggle = true
      element = element_for_spec

      expect {Gatling.matches?('orange.png', element)}.should_not raise_error
      File.exists?(File.join(@ref_path,'orange.png')).should be_true
    end

    it 'should alert that the file should be deleted if a reference already exists and not overwrite file' do
      create_reference_for_tests(@ref_path)
      Gatling::Configuration.trainer_toggle = true
      element = element_for_spec

      reference_file_ctime = File.ctime(File.join(@ref_path,'orange.png'))
      sleep(1)
      expect {Gatling.matches?('orange.png', element)}.should_not raise_error

      #checks if file was overwritten by comparing the time stamps
      reference_file_ctime.eql?(File.ctime(File.join(@ref_path,'orange.png'))).should be_true
    end

  end

  # MOCK SELENIUM ELEMENT
  # correct size (340px*42px)
  # image magick saves screenshot
  #create diff creates the correct candidate


end

