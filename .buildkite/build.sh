#!/bin/bash

set -e

echo '+++ Build Assets + Gem'
bundle exec cyborg gem:build
