#!/bin/bash

set -e

echo '+++ Publish to rubygems.org'
curl --data-binary @megatron-`bundle exec ruby -e pkg/'puts Gem.loaded_specs["megatron"].version'`.gem \
  -H "Authorization:$RUBYGEMS_API_KEY" \
  -H "Content-Type: application/octet-stream" \
  https://rubygems.org/api/v1/gems

echo '+++ Upload to CDN'
bundle exec rake megatron:upload
