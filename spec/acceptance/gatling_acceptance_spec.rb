require 'spec_helper'
include Capybara::DSL

describe 'Gatling' do

  before(:all) do
    @spec_support_root = spec_support_root
  end

  before(:each) do
    @ref_path = Gatling::Configuration.reference_image_path = File.join(spec_support_root, 'ref_path')
  end

  after(:each) do
    remove_refs(@ref_path)
    Gatling::Configuration.trainer_toggle = false
  end

  describe 'Gatling, when no reference image exists' do

    it "will notify that no reference image exists and create a candidate image" do
      black_element = element_for_spec
      expected_error = "The design reference #{"black.png"} does not exist, #{@ref_path}/candidate/#{"black.png"} " +
                       "is now available to be used as a reference. " +
                       "Copy candidate to root reference_image_path to use as reference"

      expect {Gatling.matches?("black.png", black_element)}.should raise_error(RuntimeError, expected_error)

      File.exists?(File.join(@ref_path, 'candidate', "black.png")).should be_true
    end
  end

  describe 'Gatling image comparison' do

    before(:each) do
      create_square_image(@ref_path, 'black')
    end

    it 'will return true if the images are identical' do
      black_element = element_for_spec('#black')

      Gatling.matches?("black.png", black_element).should be_true
    end

    it 'will return false, creates new diff and candidate images if the images are different' do
      red_element = element_for_spec('#red')
      expected_error = "element did not match #{"black.png"}. " +
                       "A diff image: #{"black.png"} was created in #{@ref_path}/diff/#{"black.png"} " +
                       "A new reference #{@ref_path}/candidate/#{"black.png"} can be used to fix the test"

      expect {Gatling.matches?("black.png", red_element)}.should raise_error(RuntimeError, expected_error)

      File.exists?(File.join(@ref_path,'diff', "black.png")).should be_true
      File.exists?(File.join(@ref_path,'candidate', "black.png")).should be_true
    end

    # it 'will try to match a specified amount of time before failing' do
    #      red_element = element_for_spec('#red')
    #      Gatling.should_receive(:matches?).and_return(false)
    #      Gatling.should_receive(:try_until_match)
    #      Gatling.matches?("black.png", red_element)
    #    end

  end

  describe 'Gatling trainer toggle' do

    it 'will save a reference file if no reference file already exists' do
      Gatling::Configuration.trainer_toggle = true
      File.exists?(File.join(@ref_path, "black.png")).should be_false
      $stdout.should_receive(:puts).with "Saved #{@ref_path}/#{"black.png"} as reference"
      black_element = element_for_spec

      expect {Gatling.matches?("black.png", black_element)}.should_not raise_error

      File.exists?(File.join(@ref_path, "black.png")).should be_true
    end

    it 'will warn if a reference already exists and not overwrite it' do
      create_square_image(@ref_path, 'black')
      Gatling::Configuration.trainer_toggle = true
      expected_message = "#{File.join(@ref_path,"black.png")} already exists. reference image was not overwritten. " +
                         "please delete the old file to update using trainer"
      black_element = element_for_spec
      reference_file_ctime = File.ctime(File.join(@ref_path,"black.png"))

      $stdout.should_receive(:puts).with expected_message
      expect {Gatling.matches?("black.png", black_element)}.should_not raise_error

      sleep(1)
      reference_file_ctime.eql?(File.ctime(File.join(@ref_path, "black.png"))).should be_true
    end
  end
end
