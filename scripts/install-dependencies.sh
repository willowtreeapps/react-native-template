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
elif [ -f "pnpm-lock.yaml" ]; then
    PACKAGE_MANAGER="pnpm"
else
    echo "No lock file found."
    echo "Please use one from https://github.com/jpdriver/react-native-template"
    exit 1
fi

# Install dependencies
echo "Running '$PACKAGE_MANAGER install' in ${PWD}"

corepack enable $PACKAGE_MANAGER
# if package.json does not include a `packageManager` field, add it
if ! grep -q '"packageManager":' package.json; then
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
        corepack use yarn@v1
    elif [ "$PACKAGE_MANAGER" = "npm" ]; then
        corepack use npm
    elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
        corepack use pnpm
    fi
else
    corepack $PACKAGE_MANAGER install
fi

# Update PR Checks GitHub Action if required
if [ "$PACKAGE_MANAGER" = "yarn" ]; then
    sed -i '' 's/cache: npm/cache: yarn/g' .github/workflows/PR\ Checks.yml
    sed -i '' 's/cache-dependency-path: package-lock.json/cache-dependency-path: yarn.lock/g' .github/workflows/PR\ Checks.yml
    sed -i '' 's/npm install/yarn install/g' .github/workflows/PR\ Checks.yml
    sed -i '' 's/npm run/yarn/g' .github/workflows/PR\ Checks.yml
    sed -i '' 's/npx/yarn/g' .github/workflows/PR\ Checks.yml
fi