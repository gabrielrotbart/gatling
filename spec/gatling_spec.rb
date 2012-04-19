require 'spec_helper'
include Capybara::DSL

describe Gatling do

  before :all do
    @spec_support_root = spec_support_root
    @box = 'box'
    @black_box = 'black.png'
    @red_box = 'red.png'
    @ref_path = Gatling::Configuration.reference_image_path = './ref_path'
  end

  after :each  do
    Gatling::Configuration.trainer_toggle = false
  end

  describe 'Gatling' do

    it 'will return true if the images are identical' do
      pending
      element = element_for_spec



      Gatling.matches?(@black_box, mock_element).should(be_true)
    end
  end
end