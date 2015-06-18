# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mumukit/version'

Gem::Specification.new do |spec|
  spec.name          = 'mumukit'
  spec.version       = Mumukit::VERSION
  spec.authors       = ['Franco Leonardo Bulgarelli']
  spec.email         = ['flbulgarelli@yahoo.com.ar']
  spec.summary       = 'Mumuki Test Server Development Kit'
  spec.description   = 'Helpers for building a Mumuki Test Server'
  spec.homepage      = 'https://github.com/flbulgarelli/mumukit'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*', 'locales/**']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2'
  spec.add_development_dependency 'codeclimate-test-reporter'

  spec.add_dependency 'sinatra', '~> 1.4'
  spec.add_dependency 'i18n', '~> 0.7'

end
