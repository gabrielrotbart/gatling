require 'spec_helper'
include Capybara::DSL


describe 'Gatling' do


  before(:all) do
    @black_box = 'black.png'
    @red_box = 'red.png'
    create_images_for_web_page

  end

  before(:each) do
    @ref_path = Gatling::Configuration.reference_image_path = File.join(spec_support_root, 'ref_path')
  end

  after(:each) do
    remove_refs(@ref_path)
  end

  describe 'Galing, when no reference image exists' do

    it "will notify that no reference image exists and create a candidate image" do
      gatling = gatling_for_spec(@black_box, '#black')
      expected_error = "The design reference #{@black_box} does not exist, #{@ref_path}/candidate/#{@black_box} " +
                       "is now available to be used as a reference. " +
                       "Copy candidate to root reference_image_path to use as reference"

      expect {gatling.matches?}.should raise_error(RuntimeError, expected_error)
      File.exists?(File.join(@ref_path, 'candidate', @black_box)).should be_true
    end
  end

  describe 'Gatling image comparison' do

    before(:each) do
      create_square_image(@ref_path, 'black')
    end

    it 'will return true if the images are identical' do
     gatling = gatling_for_spec(@black_box, '#black')
     gatling.matches?.should be_true
    end

    it 'will return false, creates new diff and candidate images if the images are different' do
       gatling = gatling_for_spec(@black_box, '#red')
       expected_error = "element did not match #{@black_box}. " +
                        "A diff image: #{@black_box} was created in #{@ref_path}/diff/#{@black_box}. " +
                        "A new reference #{@ref_path}/candidate/#{@black_box} can be used to fix the test"

       expect {gatling.matches?}.should raise_error(RuntimeError, expected_error)
       File.exists?(File.join(@ref_path,'diff', @black_box)).should be_true
       File.exists?(File.join(@ref_path,'candidate', @black_box)).should be_true
    end
  end

  describe 'Gatling trainer toggle' do

    it 'will save a reference file if no reference file already exists' do
      Gatling::Configuration.trainer_toggle = true
      $stdout.should_receive(:puts).with "Saved #{@ref_path}/#{@black_box} as reference"
      File.exists?(File.join(@ref_path, @black_box)).should be_false
      gatling = gatling_for_spec(@black_box)

      expect {gatling.matches?}.should_not raise_error
      File.exists?(File.join(@ref_path, @black_box)).should be_true
    end

    it 'will warn if a reference already exists and not overwrite it' do
      create_square_image(@ref_path, 'black')
      Gatling::Configuration.trainer_toggle = true
      expected_message = " already exists. reference image was not overwritten. " +
                          "please delete the old file to update using trainer"

      $stdout.should_receive(:puts).with expected_message
      gatling = gatling_for_spec(@black_box)

      reference_file_ctime = File.ctime(File.join(@ref_path, @black_box))
      sleep(1)
      expect {gatling.matches?}.should_not raise_error

      #checks if file was overwritten by comparing the time stamps
      reference_file_ctime.eql?(File.ctime(File.join(@ref_path, @black_box))).should be_true
    end

  end

  # MOCK SELENIUM ELEMENT
  # correct size (340px*42px)
  # image magick saves screenshot
  #create diff creates the correct candidate


end

