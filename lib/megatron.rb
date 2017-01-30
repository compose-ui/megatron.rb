Gem.loaded_specs['megatron'].dependencies.each do |d|
  require d.name
end

require 'megatron/version'
require 'megatron/helper'

module Megatron
  class Plugin < Cyborg::Plugin
  end
end

Cyborg.register(Megatron::Plugin, {
  gem: 'megatron',
  engine: 'megatron',
  production_asset_root: "https://d11f55tj5eo9e5.cloudfront.net/assets/megatron/"
})
