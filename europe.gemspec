# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'europe/version'

Gem::Specification.new do |spec|
  spec.name          = 'europe'
  spec.version       = Europe::VERSION
  spec.authors       = ['Gem shards']
  spec.email         = ['vincent@gemshards.com']
  spec.summary       = 'Europe is a gem for retrieving and validating ' \
                       'EU government data.'
  spec.description   = 'Europe is a simple library for retrieving ' \
                       'EU government data such as VAT information, ' \
                       'VAT validation, currency exchange rates and ' \
                       'country information.'
  spec.homepage      = 'https://github.com/gem-shards/europe.rb'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'minitest-reporters'
  spec.add_development_dependency 'awesome_print'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'webmock'
end
