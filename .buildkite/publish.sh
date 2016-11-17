#!/bin/bash

set -e

curl --data-binary @megatron-`bundle exec ruby -e 'puts Gem.loaded_specs["megatron"].version'`.gem \
  -H "Authorization:$RUBYGEMS_API_KEY" \
  -H "Content-Type: application/octet-stream" \
  https://rubygems.org/api/v1/gems
