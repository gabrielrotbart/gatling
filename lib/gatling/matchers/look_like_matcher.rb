require 'gatling'

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    compare = Gatling::Fire.new(expected, actual)
    compare.matches?
  end
end