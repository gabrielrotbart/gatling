require 'spec_helper'
include Capybara::DSL

describe 'rspec matcher' do

  before(:all) do
    @black_box = 'black.png'
    @ref_path = Gatling::Configuration.reference_image_path = File.join(spec_support_root, 'ref_path')
    create_images_for_web_page
  end

  after(:each) do
    Gatling::Configuration.trainer_toggle = false
    remove_refs(@ref_path)
  end

  describe 'initializing and runnin gatling' do

    it 'will pass if images matches reference' do
      create_square_image(@ref_path, 'black')
      black_element = element_for_spec("#black")
      black_element.should look_like("black.png")
    end

    it 'will fail if images dosent matches reference' do
      create_square_image(@ref_path, 'black')
      red_element = element_for_spec("#red")
      expect{red_element.should look_like(@black_box)}.should raise_error
    end

    it 'will return true if it makes a new reference image in trainer mode' do
      Gatling::Configuration.trainer_toggle =  true
      black_element = element_for_spec("#black")
      black_element.should look_like(@black_box)
      File.exists?(File.join(@ref_path, @black_box)).should be_true
    end

  end
end
