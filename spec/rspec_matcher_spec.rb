require 'spec_helper'
include Capybara::DSL


describe 'rspec matcher' do

  before(:all) do
    @black_box = 'black.png'
    @ref_path = Gatling::Configuration.reference_image_path = File.join(spec_support_root, 'ref_path')

    create_images_for_web_page
    create_square_image(@ref_path, 'black')
  end

  after(:each) do
    remove_refs(@ref_path)
  end

  it 'should initialize and run gatling' do
    visit('/fruit_app.html')
    black_element = page.find(:css, "#black")
    black_element.should look_like(@black_box)
  end

  it 'should initialize and run training mode when GATLING_TRAINER is toggled' do
    ENV['GATLING_TRAINER'] = 'true'

    visit('/fruit_app.html')
    black_element = page.find(:css, "#black")
    black_element.should look_like(@black_box)
    File.exists?(File.join(@ref_path,@black_box)).should be_true
  end

end
