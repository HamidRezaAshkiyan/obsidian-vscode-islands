# AGENTS.md — VS Code Modern Islands (Obsidian Theme)

## Overview
An Obsidian CSS theme (**VS Code Modern Islands**) that preserves 100% of Obsidian's default Dark and Light themes (colors, accent color, typography, and syntax highlighting) while applying VS Code Modern-inspired floating workspace islands (`6px` gaps, `1px` hairline borders) and a unified subtle rounded-corner scale (`8px` islands, `6px` inputs/buttons/blocks, `4px` tabs/tags/checkboxes).

## Tech Stack & Requirements
- **Styling:** Pure CSS (`theme.css`, no preprocessor or build step)
- **Platform:** Obsidian Themes API (`minAppVersion: 1.6.0`)
- **Optional Plugin Integration:** [Style Settings](https://github.com/mgmeyers/obsidian-style-settings) (exposes live CSS variable sliders via embedded YAML `@settings` comment block in `theme.css`)
- **Tooling:** Bash install script (`scripts/install.sh`) and static HTML browser preview (`preview/index.html`)

## Repository Structure
```text
.
├── manifest.json            # Obsidian theme manifest (name: "VS Code Modern Islands", minAppVersion: 1.6.0)
├── theme.css                # Complete theme stylesheet (~415 lines): tokens, island layout, Style Settings block
├── README.md                # Feature overview, installation, and browser preview instructions
├── scripts/
│   └── install.sh           # Copies or symlinks (--symlink) manifest.json & theme.css into a vault's themes dir
├── preview/
│   └── index.html           # Interactive browser preview mocking Obsidian's Light/Dark DOM over theme.css
└── assets/
    ├── preview-dark.png     # Dark mode screenshot
    └── preview-light.png    # Light mode screenshot
```

## Architecture & Key Flows
- **CSS Variable Layer (`theme.css`):** Defines core island geometry tokens (`--island-radius: 8px`, `--island-gap: 6px`, `--island-border-width: 1px`), unified radius scale (`--radius-xs` through `--radius-xl`), removes hard dividers (`--divider-width: 0px`), and inherits Obsidian's native surface variables (`--background-secondary-alt`, `--background-modifier-border`).
- **Workspace Island Selectors:** Transforms `.titlebar` / `.titlebar-inner` (including `body.is-hidden-frameless`), ribbon, left/right sidebars, split editor panes, vault switcher footer, and status bar into self-contained rounded islands over `--island-canvas`.
- **Browser Preview (`preview/index.html`):** Loads `../theme.css` directly in a browser with Obsidian's default Light/Dark CSS variables for rapid visual iteration without restarting Obsidian.

## Development & Commands
No build step or package manager is required.
```bash
# Install into an Obsidian vault (copy)
./scripts/install.sh /path/to/your/vault

# Symlink into an Obsidian vault for live CSS editing
./scripts/install.sh --symlink /path/to/your/vault

# Preview theme.css in a browser (Light & Dark modes)
python3 -m http.server 8765
# Open http://localhost:8765/preview/
```

## Configuration & Environment
No environment variables. User-facing customization is exposed via Obsidian's **Style Settings** plugin (`--island-radius`, `--island-gap`, `--island-border-width`) defined inside `theme.css`.

## Conventions & Gotchas
- **Do Not Override Native Colors or Typography:** The core design principle is inheriting Obsidian's default palette, user accent color, fonts, and Markdown syntax styles. Always reference Obsidian CSS variables (e.g., `var(--background-secondary)`, `var(--background-modifier-border)`) rather than hardcoded hex colors (except subtle alpha shadows in `.theme-dark` / `.theme-light`).
- **Preserve Hidden-Frameless & Split-Pane Behavior:** Test changes against both normal and `body.is-hidden-frameless` titlebar modes, collapsed/expanded sidebars, and split panes.
- **No Build Output:** `theme.css` and `manifest.json` at the repo root are installed directly by Obsidian. Keep `manifest.json` version in sync with the header comment in `theme.css`.
