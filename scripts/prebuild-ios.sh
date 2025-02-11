#!/bin/bash

# Install Cocoapods as a local gem
if [ ! -d "vendor" ]; then
  bundle install
fi

# Use Expo CLI to generate the native iOS project
npx expo prebuild --platform ios --no-install

# Install the iOS dependencies using Cocoapods
bundle exec pod install --repo-update --project-directory=ios