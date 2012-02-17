require 'spec_helper'
require 'gatling'

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    compare = Gatling::Comparison.new(expected, actual)
    compare.run
  end
end