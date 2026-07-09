#!/bin/bash
set -e  # Exit on error

MODULE_DIRS=(modules/*)

for DIR_NAME in "${MODULE_DIRS[@]}"; do 
  ROOT_TSCONFIG_PATH="${DIR_NAME}/tsconfig.json"
  PLUGIN_TSCONFIG_PATH="${DIR_NAME}/plugin/tsconfig.json"

  if [ -f "$ROOT_TSCONFIG_PATH" ]; then
    echo "Compiling ${DIR_NAME} (root tsconfig)..."
    npx tsc -p "$ROOT_TSCONFIG_PATH"
  fi

  if [ -f "$PLUGIN_TSCONFIG_PATH" ]; then
    echo "Compiling ${DIR_NAME} (plugin tsconfig)..."
    npx tsc -p "$PLUGIN_TSCONFIG_PATH"
  fi
done