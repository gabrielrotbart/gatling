require 'spec_helper'
include Capybara::DSL

describe 'rspec matcher' do

  before(:each) do
    @black_box = 'black.png'
    @ref_path = Gatling.reference_image_path = File.join(spec_support_root, 'ref_path')
    create_images_for_web_page
  end

  after(:each) do
    config_clean_up
    remove_refs(@ref_path)
  end

  describe 'initializing and runnin gatling' do

    it 'will pass if images matches reference' do
      create_square_image(@ref_path, 'black')
       black_element = element_for_spec("#black")
      black_element.should look_like("black.png")
    end

    it "will fail if images doesn't matches reference" do
      create_square_image(@ref_path, 'black')
      red_element = element_for_spec("#red")
      expect{red_element.should look_like(@black_box)}.should raise_error
    end

  end
end
