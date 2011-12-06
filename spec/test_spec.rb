require 'spec_helper'
include Capybara::DSL

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    compare = Gatling::Comparison.new(expected, actual)
    compare.matches?
  end
end


describe "Google search" do
  it "should compare" do
   visit('/')
   page.find(:css, '#hplogo').should look_like('google_logo.png')
  end
end

describe "Reddit" do
  it "should visit reddit" do
    visit('http://www.reddit.com')
  end
end    




