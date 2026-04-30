# RAT v2 Source Package

This folder contains the reviewable source files for the RAT v2 Tauri app.

## Contents

- `src/index.html` - frontend UI, styling, and browser-side app logic.
- `src/index.js` - supporting JavaScript from the original app bundle.
- `src/assets/` - app assets used by the frontend.
- `src/src-tauri/` - Rust/Tauri backend source, config, icons, and permissions.
- `src/package.json` and `src/package-lock.json` - Node/Tauri build metadata.
- `scripts/` - bundled script examples included with the project.

## Not Included

Generated or local-only files are intentionally excluded:

- `node_modules/`
- `src/src-tauri/target/`
- `src/tauri-dist/`
- `.app`, `.dmg`, and `.zip` build artifacts
- account data or local runtime state
- macOS `.DS_Store` files

## Build

From `RAT-v2-source/src`:

```sh
npm install
npm run build
```

The Tauri app source is in `src/src-tauri`.
