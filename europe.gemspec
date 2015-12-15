# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'europe/version'

Gem::Specification.new do |spec|
  spec.name          = 'europe'
  spec.version       = Europe::VERSION
  spec.authors       = ['VvanGemert']
  spec.email         = ['vincent@floorplanner.com']
  spec.summary       = 'Europe is a helper gem for retrieving \
                        EU government data'
  spec.description   = 'This gem retrieves data from EU government websites'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'nokogiri', '~> 1.6'
  spec.add_dependency 'savon', '~> 2.10.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'pry'
end
