#!/bin/bash

echo '+++ Upload to rubygems'
curl --data-binary @megatron-`bundle exec ruby -e 'puts Gem.loaded_specs["megatron"].version'`.gem \
-H "Authorization:$RUBYGEMS_API_KEY" \
https://rubygems.org/api/v1/gems