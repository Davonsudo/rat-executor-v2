#!/bin/bash

set -euo pipefail

cd "$(dirname "$0")"

echo "Preparing RAT Executor frontend for Tauri..."
node ./prepare-tauri-frontend.mjs

echo "Cleaning previous Tauri build artifacts..."
rm -rf ./src-tauri/target/release/bundle

echo "Building RAT Executor Tauri app bundle..."
./node_modules/.bin/tauri build --bundles app

echo "Build complete. App bundle output:"
find ./src-tauri/target/release/bundle/macos -maxdepth 1 -type d -name "*.app"
