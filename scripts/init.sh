#!/bin/bash
set -e  # Exit on error

# Check for conflicting lock files
if [ -f "yarn.lock" ] && [ -f "package-lock.json" ]; then
    echo "Error: Both yarn.lock and package-lock.json exist"
    echo "Please remove one of the lock files to avoid conflicts"
    exit 1
fi

# Determine package manager
if [ -f "yarn.lock" ]; then
    PACKAGE_MANAGER="yarn"
elif [ -f "package-lock.json" ]; then
    PACKAGE_MANAGER="npm"
else
    echo "No lock file found."
    echo "Please use one from https://github.com/willowtreeapps/react-native-template"
    exit 1
fi

# Clean project
rm -rf .expo android ios node_modules vendor

# Install dependencies
$PACKAGE_MANAGER install

# Prebuild native projects
npx expo prebuild --platform android
npx expo prebuild --platform ios --no-install

# Install the iOS dependencies using Cocoapods
bundle install
bundle exec pod install --repo-update --project-directory=ios

# Install Maestro
if ! command -v maestro &> /dev/null; then
    curl -fsSL "https://get.maestro.mobile.dev" | bash
    brew tap mobile-dev-inc/tap
    brew install maestro
fi