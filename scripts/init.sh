#!/bin/bash
set -e  # Exit on error

# Check tool versions
./scripts/check-tool-versions.sh

# Clean project
./scripts/clean.sh

# Install dependencies
./scripts/install-dependencies.sh

# Prebuild native projects
./scripts/prebuild.sh