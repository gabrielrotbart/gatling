require 'spec_helper'
include Capybara::DSL

describe 'Gatling' do

  before(:all) do
    @spec_support_root = spec_support_root
    @black_box = 'black.png'
    @red_box = 'red.png'
  end

  before(:each) do
    @ref_path = Gatling::Configuration.reference_image_path = File.join(spec_support_root, 'ref_path')
  end

  after(:each) do
    remove_refs(@ref_path)
  end

  describe 'Gatling, when no reference image exists' do

    it "will notify that no reference image exists and create a candidate image" do
      pending
      mock_element = mock
      mock_element.stub(:native).and_return(mock_element)

      expected_error = "The design reference #{@black_box} does not exist, #{@ref_path}/candidate/#{@black_box} " +
                       "is now available to be used as a reference. " +
                       "Copy candidate to root reference_image_path to use as reference"

      expect {Gatling.matches?(@black_box, mock_element)}.to raise_error(RuntimeError, expected_error)

      File.exists?(File.join(@ref_path, 'candidate', @black_box)).should be_true
    end
  end
end