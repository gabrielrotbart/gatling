# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gatling/version"

Gem::Specification.new do |s|
  s.name        = "gatling"
  s.version     = Gatling::VERSION
  s.authors     = ["Gabriel Rotbart, Amanda Koh, Mike Bain"]
  s.email       = ["grotbart@gmail.com"]
  s.homepage    = "http://github.com/GabrielRotbart/gatling"
  s.summary     = %q{Automated visual testing}
  s.description = %q{Add visual comparison matchers for rspec}

  s.rubyforge_project = "gatling"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency('rmagick', ['>=2.13.1'])
  s.add_runtime_dependency('rspec',['>=2.9.0'])
  s.add_runtime_dependency('capybara',['>=1.1.2'])

  s.add_development_dependency('rake',['>=0.9.2'])
  s.add_development_dependency('rspec-instafail',['>=0.1.8'])
  s.add_development_dependency('pry',['>=0.9.8.2'])
  s.add_development_dependency('selenium-webdriver',['~> 2.33.0'])
end
