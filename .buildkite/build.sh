#!/bin/bash

set -e

echo '+++ Clean'
make clean

echo '+++ Build'
make build

echo '+++ Upload'
bundle exec rake megatron:upload

echo '+++ Build gemspec'
gem build megatron.gemspec
