# RAT Executor

Clean source snapshot for the RAT Executor Tauri desktop app.

## Included

- `index.html` - frontend UI, styles, and browser-side logic.
- `index.js` - desktop app support code from the original package.
- `assets/` - frontend assets.
- `src-tauri/` - Tauri/Rust backend, config, permissions, and icons.
- `package.json`, `package-lock.json`, `Cargo.toml`, and `Cargo.lock` - build metadata.

## Excluded

This folder intentionally excludes generated/local files:

- `node_modules/`
- `src-tauri/target/`
- `tauri-dist/`
- app bundles, DMGs, ZIPs, and `.DS_Store`

## Build

```sh
npm install
npm run build
```
