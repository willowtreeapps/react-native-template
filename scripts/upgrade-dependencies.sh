#!/bin/bash
set -e  # Exit on error

# Determine package manager and lock file path
if [ -f "yarn.lock" ]; then
    PACKAGE_MANAGER="yarn"
	LOCK_FILE="yarn.lock"
elif [ -f "package-lock.json" ]; then
    PACKAGE_MANAGER="npm"
	LOCK_FILE="package-lock.json"
elif [ -f "pnpm-lock.yaml" ]; then
    PACKAGE_MANAGER="pnpm"
	LOCK_FILE="pnpm-lock.yaml"
else
    echo "No lock file found."
    echo "Please use one from https://github.com/jpdriver/react-native-template"
    exit 1
fi

# Install dependencies
echo "Running '$PACKAGE_MANAGER install expo@latest' in ${PWD}"

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
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
		corepack $PACKAGE_MANAGER add expo@latest
	elif [ "$PACKAGE_MANAGER" = "npm" ]; then
		corepack $PACKAGE_MANAGER install expo@latest
	fi
fi

# Parse package.json with Object.keys on dependencies and devDependencies
DEPENDENCIES_BY_TYPE=$(node -e '
  try {
	const fs = require("fs");
	const pkg = JSON.parse(fs.readFileSync("package.json", "utf8"));
	const deps = Object.keys(pkg.dependencies || {});
	// Keep these pinned to align with the upstream React Native CLI template.
	const pinnedDeps = [
		"@babel/core",
		"@react-native/eslint-config",
		"@react-native/jest-preset",
		"babel-loader",
		"eslint",
		"prettier"
	];
	const devDeps = Object.keys(pkg.devDependencies || {}).filter(
	  (name) => !pinnedDeps.includes(name)
	);
	console.log(`deps:${deps.join(" ")}`);
	console.log(`devDeps:${devDeps.join(" ")}`);
  } catch (e) {
	console.error("Failed to parse package.json:", e.message);
	process.exit(1);
  }
' 2>/dev/null)

deps_line=$(echo "$DEPENDENCIES_BY_TYPE" | grep '^deps:' || true)
dev_deps_line=$(echo "$DEPENDENCIES_BY_TYPE" | grep '^devDeps:' || true)

deps_list="${deps_line#deps:}"
dev_deps_list="${dev_deps_line#devDeps:}"

# Install dependencies using expo install
# Note: expo install will fail if the package is unable to modify app.json, so we need to handle that gracefully
if [ -n "$deps_list" ]; then
	echo "Upgrading dependencies"
	if ! npx expo install $deps_list; then
		echo "Warning: expo install for dependencies failed"
	fi
else
	echo "No dependencies found in package.json"
fi

# Install devDependencies using expo install
if [ -n "$dev_deps_list" ]; then
	echo "Upgrading devDependencies"
	npx expo install $dev_deps_list --dev
else
	echo "No devDependencies found in package.json"
fi

# Remove the lock file to ensure a clean state for the next install
rm -f "$LOCK_FILE"
touch "$LOCK_FILE"

# Run the init script to ensure the project is properly set up after dependency upgrades
./scripts/init.sh
