require 'spec_helper'
include Capybara::DSL


describe 'rspec matcher' do

  before(:all) do

    #expected image to compare with
    @example_good_image = 'orange.png'

    @spec_support_root = spec_support_root

    @ref_path = Gatling::Configuration.reference_image_path = File.join(@spec_support_root, 'ref_path')
    create_reference_for_tests(File.join('spec','support','assets'))
  end


  after(:each) do
    remove_refs(@ref_path)
  end

  it 'should initialize and run gatling' do
    create_reference_for_tests(@ref_path)

    visit('/fruit_app.html')
    @element = page.find(:css, "#orange")
    @element.should look_like('orange.png')
  end

  # it 'should exclude a specified child css element' do
  #   create_reference_for_tests(@ref_path)

  #   visit('/')
  #   @element = page.find(:css, "#orange")
  #   @element.should look_like('orange.png', :exclude => '#changable').should be_true
  # end


  it 'should initialize and run training mode when GATLING_TRAINER is toggled' do
    ENV['GATLING_TRAINER'] = 'true'

    visit('/fruit_app.html')
    @element = page.find(:css, "#orange")
    @element.should look_like('orange.png')
    File.exists?(File.join(@ref_path,'orange.png')).should be_true
  end

end