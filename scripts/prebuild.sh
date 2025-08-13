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

# Determine platforms, defaulting to both if missing/unreadable
PLATFORMS=("ios" "android")
PLATFORMS_RAW=$(node -e '
  try {
    const fs = require("fs");
    const cfg = JSON.parse(fs.readFileSync("app.json", "utf8"));
    const p = (cfg && cfg.expo && cfg.expo.platforms) || cfg.platforms;
    if (Array.isArray(p)) {
      console.log(p.filter(Boolean).join(","));
    }
  } catch (e) {
    // fall back to default
  }
' 2>/dev/null || true)

if [[ -n "$PLATFORMS_RAW" ]]; then
  IFS=',' read -r -a PLATFORMS <<< "$PLATFORMS_RAW"
fi

# If a single platform was requested, ensure it's enabled and then narrow to it
if [[ -n "$PLATFORM" ]]; then
  if [[ ! " ${PLATFORMS[*]} " =~ ${PLATFORM} ]]; then
    echo "Error: Platform '$PLATFORM' is not enabled in app.json. Enabled platforms: ${PLATFORMS[*]}"
    exit 1
  fi
  PLATFORMS=("$PLATFORM")
fi

# Clean native projects
rm -rf android ios

# Compile Expo modules
./scripts/compile-plugins.sh

# Prebuild native projects
# If android is among enabled platforms
if [[ " ${PLATFORMS[*]} " =~ android ]]; then
  npx expo prebuild --platform android
fi

# If iOS is among enabled platforms
if [[ " ${PLATFORMS[*]} " =~ ios ]]; then
  npx expo prebuild --platform ios --no-install
  
  # Needed for Ruby v3
  export RUBY_TCP_NO_FAST_FALLBACK=1

  # Install Ruby Gems such as Cocoapods (if not already installed)
  if [[ ! -d vendor ]]; then
    bundle install
  fi

  # Install the iOS dependencies using Cocoapods
  bundle exec pod install --repo-update --project-directory=ios
fi