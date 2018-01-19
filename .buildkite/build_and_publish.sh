#!/bin/bash

set -e

echo "+++ Running build script"

.buildkite/build.sh

if [ "$BUILDKITE_BRANCH" == "master" ]; then
  echo "+++ Running publish script"
  .buildkite/publish.sh
else
  echo "Skipping publish - current branch ($BUILDKITE_BRANCH) is not master"
fi
