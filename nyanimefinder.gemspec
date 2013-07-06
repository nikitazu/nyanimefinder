# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nyanimefinder/version'

Gem::Specification.new do |spec|
  spec.name          = "nyanimefinder"
  spec.version       = Nyanimefinder::VERSION
  spec.authors       = ["Nikita B. Zuev"]
  spec.email         = ["nikitazu@gmail.com"]
  
  spec.description   = %q{Various web scrapers searching for anime descriptions, 
                          and providing them in parseable format.}
                          
  spec.summary       = %q{see description...}
  
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  
  # unit testing
  spec.add_development_dependency 'rspec', '~> 2.6'
  
  # cli testing
  spec.add_development_dependency 'cucumber', '~> 1.3'
  spec.add_development_dependency 'aruba', '~> 0.5'
  
  # web scraping
  spec.add_dependency 'nokogiri', '~> 1.5'
  
  # cli
  spec.add_dependency "thor", '~> 0.18'
end
