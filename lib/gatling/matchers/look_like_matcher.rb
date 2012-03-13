require 'gatling'

RSpec::Matchers.define :look_like do |expected|
  match do |actual|
    compare = Gatling.matches?(expected, actual)
  end
end