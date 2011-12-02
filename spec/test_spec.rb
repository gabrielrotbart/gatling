require 'spec_helper'
include Capybara::DSL

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    compare = Comparison.new(expected, actual)
    compare.matches?
  end
end


describe "Google search" do
  it "should compare" do
   visit('/')
   page.find(:css, '#hplogo').should look_like('google_logo.png')
  end
  # it "should visit again" do
  #  visit('/')
  #  page.find(:css, '#hplogo').should look_like('google_logo_clean.png')
  # end
end

describe "Reddit" do
  it "should visit reddit" do
    visit('http://www.reddit.com')
  end
end      




