#!/bin/bash

set -e

echo '+++ Test'
bundle exec rspec

echo '+++ Build Assets + Gem'
bundle exec cyborg gem:build
