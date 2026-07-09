#!/bin/bash
set -e  # Exit on error

# Run version checks only on macOS.
# This script is invoked from npm preinstall and should not fail Linux CI runners.
if [ "$(uname -s)" != "Darwin" ]; then
	echo "Skipping tool version checks on non-macOS: $(uname -s)"
	exit 0
fi

# Derive required Ruby version from .ruby-version (project source of truth).
# Supported forms:
#   3.4.5
#   ruby-3.4.5
REQUIRED_RUBY_VERSION="$(head -1 .ruby-version | tr -d '[:space:]' | sed -E 's/^ruby-//')"
REQUIRED_XCODE_VERSION="26.4"
REQUIRED_NODE_VERSION="22.22.1"

# Compare semantic versions (major.minor.patch) numerically.
version_ge() {
	# returns 0 (success) if $1 >= $2
	local IFS=.
	local i ver1=($1) ver2=($2)
	# pad shorter array
	local len=${#ver1[@]}
	if (( ${#ver2[@]} > len )); then len=${#ver2[@]}; fi
	for ((i=0; i<len; i++)); do
		local a=${ver1[i]:-0}
		local b=${ver2[i]:-0}
		if ((10#${a} > 10#${b})); then return 0; fi
		if ((10#${a} < 10#${b})); then return 1; fi
	done
	return 0
}

# Ruby version check
# ruby -v typical output:
#   ruby 3.4.5p12 (2025-07-01 revision 123abc) [arm64-darwin23] 
RUBY_RAW="$(ruby -v 2>/dev/null || true)"
CURRENT_RUBY_VERSION="$(echo "${RUBY_RAW}" | awk '{print $2}' | sed 's/p.*//')"

if ! version_ge "${CURRENT_RUBY_VERSION}" "${REQUIRED_RUBY_VERSION}"; then
	echo "💥 Ruby version too low: current ${CURRENT_RUBY_VERSION}, required >= ${REQUIRED_RUBY_VERSION}"
	echo ""
	echo "You should use a Ruby Version manager such as rbenv or RVM:"
	echo "  brew install rbenv"
	echo ""
	echo "Then run:"
	echo "  rbenv init"
	exit 1
fi

# Xcode version check
# xcodebuild -version typical output:
#   Xcode 16.1
#   Build version 16B40
XCODE_RAW="$(xcodebuild -version 2>/dev/null || true)"
CURRENT_XCODE_VERSION="$(echo "${XCODE_RAW}" | awk '/Xcode/ {print $2; exit}')"

if ! version_ge "${CURRENT_XCODE_VERSION}" "${REQUIRED_XCODE_VERSION}"; then
	echo "💥 Xcode version too low: current ${CURRENT_XCODE_VERSION}, required >= ${REQUIRED_XCODE_VERSION}" >&2
    echo ""
	echo "Install / upgrade via the App Store or download from https://developer.apple.com/download/applications/" >&2
	exit 1
fi

# Node version check
# node --version typical output:
#   v20.20.0
NODE_RAW="$(node --version 2>/dev/null || true)" 
CURRENT_NODE_VERSION="$(echo "${NODE_RAW}" | sed -E 's/^v//' | sed -E 's/[-+].*$//')"


if ! version_ge "${CURRENT_NODE_VERSION}" "${REQUIRED_NODE_VERSION}"; then
	echo "💥 Node version too low: current ${CURRENT_NODE_VERSION}, required >= ${REQUIRED_NODE_VERSION}" >&2
    echo ""
    echo "Update using"
	echo "  brew install node"
    echo ""
	echo "or upgrade Node via nvm / volta" >&2
	exit 1
fi

exit 0

