#!/bin/bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
	echo "Usage: $0 <development|preview|production>"
	exit 1
fi

variant="$1"

case "$variant" in
	development|preview|production)
		;;
	*)
		echo "Invalid variant: $variant"
		echo "Allowed values: development, preview, production"
		exit 1
		;;
esac

APP_VARIANT="$variant" ./scripts/prebuild.sh --clean
