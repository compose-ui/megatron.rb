# coding: utf-8
$:.push File.expand_path('../lib', __FILE__)

require 'megatron/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'megatron'
  spec.version     = Megatron::VERSION
  spec.authors     = ['Brandon Mathis']
  spec.email       = ['brandon@imathis.com']
  spec.homepage    = 'https://www.compose.io'
  spec.summary     = 'Megatron design framework'
  spec.description = 'Megatron is a design framework for Rails.'
  spec.license     = 'MIT'

  spec.files = Dir['{app,lib,public,config}/**/*', 'LICENSE.txt', 'README.md', 'esvg.yml']

  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'cyborg'
  spec.add_runtime_dependency 'esvg', '~> 4.3'
  spec.add_runtime_dependency 'block_helpers', '~> 0.3.3'
  spec.add_runtime_dependency 'to_words', '~> 1.1.0'
  spec.add_dependency 'slim-rails', '~> 3.1'

  spec.add_dependency 'gaffe', '~> 1'
  spec.add_development_dependency 'bump', '~> 0.5.4'
end
