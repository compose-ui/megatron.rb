# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)

require "megatron/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "megatron"
  spec.version     = Megatron::VERSION
  spec.authors     = ["Brandon Mathis", "Kyle Foster"]
  spec.email       = ["brandon@imathis.com", "hkylefoster@gmail.com"]
  spec.homepage    = "https://www.compose.io"
  spec.summary     = "Megatron design framework"
  spec.description = "Megatron is a design framework for Rails."
  spec.license     = "MIT"

  spec.files = Dir["{app,lib,public}/**/*", "LICENSE.txt", "README.md"]

  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "cyborg"
  spec.add_runtime_dependency 'block_helpers', '~> 0.3.3'
  spec.add_runtime_dependency 'to_words', '~> 1.1.0'
  spec.add_dependency 'slim-rails', "~> 3.1"

  spec.add_dependency "rails", ">= 4", "< 5.1"
  spec.add_dependency "esvg", "~> 2.8"
  spec.add_dependency "gaffe", "~> 1"
end
