# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gatling/version"

Gem::Specification.new do |s|
  s.name        = "gatling"
  s.version     = Gatling::VERSION
  s.authors     = ["Gabriel Rotbart, Amanda Koh"]
  s.email       = ["grotbart@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Automated visual testing}
  s.description = %q{Add visual comparison matchers for rspec}

  s.rubyforge_project = "gatling"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "rspec"
  s.add_dependency "rmagick"
  s.add_dependency "selenium-client"
  s.add_dependency "capybara" 
end
