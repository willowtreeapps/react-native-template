#!/bin/bash
set -e  # Exit on error

# Clean project
./scripts/clean.sh

# Install dependencies
./scripts/install-dependencies.sh

# Prebuild native projects
./scripts/prebuild.sh