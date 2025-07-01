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

# Install dependencies
echo "Running '$PACKAGE_MANAGER install' in ${PWD}"
$PACKAGE_MANAGER install