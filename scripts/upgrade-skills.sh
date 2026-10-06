#!/bin/bash
set -e  # Exit on error
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

TMP_OUTPUT="$(mktemp "${TMPDIR:-/tmp}/skills-upgrade.XXXXXX")"
trap 'rm -f "$TMP_OUTPUT"' EXIT

clean_upgrade_output() {
	tr -d '\r' < "$TMP_OUTPUT" \
	| sed -E 's/'"$'\033'"'\[[0-9;]*[[:alpha:]]//g'
}

lines_to_array() {
	ARRAY_RESULT=()
	while IFS= read -r LINE_VALUE; do
		if [[ -n "$LINE_VALUE" ]]; then
			ARRAY_RESULT+=("$LINE_VALUE")
		fi
	done <<< "$1"
}

UPGRADE_EXIT=0
set +e
npx skills upgrade --project 2>&1 | tee "$TMP_OUTPUT"
UPGRADE_EXIT=${PIPESTATUS[0]}
set -e

FAILED_SKILLS="$(
	clean_upgrade_output \
	| grep -E 'Failed to update[[:space:]]+[A-Za-z][A-Za-z0-9-]*' \
	| sed -E 's/.*Failed to update[[:space:]]+([A-Za-z][A-Za-z0-9-]*).*/\1/' \
	| sort -u \
	|| true
)"

FAILED_REPOS="$(
	clean_upgrade_output \
	| grep -E 'Failed to check for deleted skills from[[:space:]]+[^[:space:]]+' \
	| grep -Eo '[A-Za-z0-9._-]+/[A-Za-z0-9._-]+' \
	| sort -u \
	|| true
)"

RECOVERY_HANDLED=false

if [[ -n "$FAILED_SKILLS" ]]; then
	lines_to_array "$FAILED_SKILLS"
	FAILED_SKILL_ARRAY=("${ARRAY_RESULT[@]}")
	echo "Removing failed skills: ${FAILED_SKILL_ARRAY[*]}"
	if ! npx skills remove "${FAILED_SKILL_ARRAY[@]}" -y; then
		echo "Error: Failed to remove one or more skills."
		exit 1
	fi

	if [[ -n "$FAILED_REPOS" ]]; then
		lines_to_array "$FAILED_REPOS"
		FAILED_REPO_ARRAY=("${ARRAY_RESULT[@]}")

		echo "Re-adding upstream repos for replacement selection: ${FAILED_REPO_ARRAY[*]}"
		for REPO_NAME in "${FAILED_REPO_ARRAY[@]}"; do
			if ! npx skills add "$REPO_NAME"; then
				echo "Error: Failed to add skill repo '$REPO_NAME'."
				exit 1
			fi
		done
	fi

		RECOVERY_HANDLED=true
	fi

	if [[ "$UPGRADE_EXIT" -ne 0 && "$RECOVERY_HANDLED" == false ]]; then
	echo "Warning: upgrade failed but no failed skill names were detected in output."
fi

	if [[ "$UPGRADE_EXIT" -ne 0 && "$RECOVERY_HANDLED" == false ]]; then
	exit 1
fi

echo "Skill upgrade complete."

