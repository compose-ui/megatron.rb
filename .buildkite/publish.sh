#!/bin/bash

set -e

echo "---\n:rubygems_api_key: $RUBYGEMS_API_KEY" > ~/.gem/credentials
chmod 0600 ~/.gem/credentials

echo '+++ Upload to rubygems'
gem push megatron-`bundle exec ruby -e 'puts Gem.loaded_specs["megatron"].version'`.gem

rm ~/.gem/credentials
