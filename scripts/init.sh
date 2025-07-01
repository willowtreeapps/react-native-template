#!/bin/bash
set -e  # Exit on error

# Clean project
rm -rf .expo android ios node_modules vendor

# Install dependencies
./scripts/install-dependencies.sh

# Prebuild native projects
./scripts/prebuild.sh

# Install Maestro
if ! command -v maestro &> /dev/null; then
    curl -fsSL "https://get.maestro.mobile.dev" | bash
    brew tap mobile-dev-inc/tap
    brew install maestro
fi