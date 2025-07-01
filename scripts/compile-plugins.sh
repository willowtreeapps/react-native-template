#!/bin/bash
set -e  # Exit on error

MODULE_DIRS=(modules/*)

for DIR_NAME in "${MODULE_DIRS[@]}"; do 
  TSCONFIG_PATH="${DIR_NAME}/plugin/tsconfig.json"
  
  if [ -f "$TSCONFIG_PATH" ]; then
    echo "Compiling ${DIR_NAME}..."
    npx tsc -p "$TSCONFIG_PATH"
  fi
done