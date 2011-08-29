require 'spec_helper'
include Capybara::DSL

describe "Google search" do
  it "blah" do
   visit('/')
   page.find(:css, '#lga').should_not be_nil
  end
end

