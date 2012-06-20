require 'spec_helper'
include Capybara::DSL

describe 'Gatling' do

  before(:all) do
    @spec_support_root = spec_support_root
  end

  before(:each) do
    @ref_path = Gatling.reference_image_path = File.join(spec_support_root, 'ref_path')
  end

  after(:each) do
    remove_refs(@ref_path)
    config_clean_up
  end

  describe 'Gatling, when no reference image exists' do

    it "will create a reference image" do
      black_element = element_for_spec
      $stdout.should_receive(:puts).with "Saved #{@ref_path}/#{"black.png"} as reference"

      Gatling.matches?("black.png", black_element).should be_true

      File.exists?(File.join(@ref_path, "black.png")).should be_true
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

    describe 'between different images of the same size' do

      it 'will return false, creates new diff and candidate images' do
        red_element = element_for_spec('#red')
        expected_error = "element did not match #{"black.png"}. " +
                         "A diff image: #{"black.png"} was created in #{@ref_path}/diff/#{"black.png"} " +
                         "A new reference #{@ref_path}/candidate/#{"black.png"} can be used to fix the test"

        expect {Gatling.matches?("black.png", red_element)}.should raise_error(RuntimeError, expected_error)

        File.exists?(File.join(@ref_path,'diff', "black.png")).should be_true
        File.exists?(File.join(@ref_path,'candidate', "black.png")).should be_true
      end

    end

    describe 'between images of the different size' do

      it 'will return false, creates new diff and candidate images' do
        red_element = element_for_spec('#differentSize')
        expected_error = "element did not match #{"black.png"}. " +
                         "A diff image: #{"black.png"} was created in #{@ref_path}/diff/#{"black.png"} " +
                         "A new reference #{@ref_path}/candidate/#{"black.png"} can be used to fix the test"

        expect {Gatling.matches?("black.png", red_element)}.should raise_error(RuntimeError, expected_error)

        File.exists?(File.join(@ref_path,'diff', "black.png")).should be_true
        File.exists?(File.join(@ref_path,'candidate', "black.png")).should be_true
      end

    end
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
                         "please delete the old file to update reference"
      black_element = element_for_spec
      reference_file_ctime = File.ctime(File.join(@ref_path,"black.png"))

      $stdout.should_receive(:puts).with expected_message
      Gatling.matches?("black.png", black_element).should be_true

      sleep(1)
      reference_file_ctime.eql?(File.ctime(File.join(@ref_path, "black.png"))).should be_true
    end
  end

  describe 'Gatling browser folders' do

    it 'should set image path according to the driver\'s browser' do
      Gatling.browser_folders = true
      Gatling.reference_image_path = '/some/random/path'
      Gatling::Configuration.reference_image_path.should == '/some/random/path/firefox'
      Gatling.browser_folders = false
    end
  end


end
