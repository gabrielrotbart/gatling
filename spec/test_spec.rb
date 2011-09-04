require 'spec_helper'
include Capybara::DSL

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    Comparison.new(expected, actual).matches?
  end
end


describe "Google search" do
  it "should compare" do
   visit('/')
   page.find(:css, '#hplogo').should look_like('google_logo.png')
  end
  it "should visit again" do
   visit('http://www.reddit.com')
  end
end




