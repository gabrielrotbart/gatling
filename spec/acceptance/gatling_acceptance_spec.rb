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

    after(:each) do
      remove_refs(@ref_path)
      config_clean_up
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

        expect {Gatling.matches?("black.png", red_element)}.to raise_error(RuntimeError, expected_error)

        File.exists?(File.join(@ref_path,'diff', "black.png")).should be_true
        File.exists?(File.join(@ref_path,'candidate', "black.png")).should be_true
      end

    end

    describe 'between images of the different size' do

      it 'will return false, creates new diff and candidate images' do
        red_element = element_for_spec('#different-size')
        expected_error = "element did not match #{"black.png"}. " +
                         "A diff image: #{"black.png"} was created in #{@ref_path}/diff/#{"black.png"} " +
                         "A new reference #{@ref_path}/candidate/#{"black.png"} can be used to fix the test"

        expect {Gatling.matches?("black.png", red_element)}.to raise_error(RuntimeError, expected_error)

        File.exists?(File.join(@ref_path,'diff', "black.png")).should be_true
        File.exists?(File.join(@ref_path,'candidate', "black.png")).should be_true
      end

    end
  end



end
