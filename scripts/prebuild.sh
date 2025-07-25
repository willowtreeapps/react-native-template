#!/bin/bash
set -e  # Exit on error

# Parse command line arguments
PLATFORM=""
if [[ $# -eq 2 && "$1" == "--platform" ]]; then
  PLATFORM="$2"
elif [[ $# -eq 0 ]]; then
  # No arguments - build all platforms
  PLATFORM=""
else
  echo "Usage: $0 [--platform android|ios]"
  exit 1
fi

# Validate platform parameter if provided
if [[ -n "$PLATFORM" && "$PLATFORM" != "android" && "$PLATFORM" != "ios" ]]; then
  echo "Error: Invalid platform '$PLATFORM'. Must be 'android' or 'ios'."
  exit 1
fi

# Clean native projects
rm -rf android ios

# Compile Expo modules
./scripts/compile-plugins.sh

# Prebuild native projects
if [[ -z "$PLATFORM" || "$PLATFORM" == "android" ]]; then
  npx expo prebuild --platform android
fi

if [[ -z "$PLATFORM" || "$PLATFORM" == "ios" ]]; then
  npx expo prebuild --platform ios --no-install
  
  # Needed for Ruby v3
  export RUBY_TCP_NO_FAST_FALLBACK=1

  # Install the iOS dependencies using Cocoapods
  bundle install
  bundle exec pod install --repo-update --project-directory=ios
fi