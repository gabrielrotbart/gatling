require 'spec_helper'
include Capybara::DSL

describe "Google search" do
  it "should compare" do
   visit('/')
   page.find(:css, '#hplogo').should look_like('google_logo.png')
  end
end
# 
# describe "Reddit" do
#   it "should visit reddit" do
#     visit('http://www.reddit.com')
#   end
# end    




