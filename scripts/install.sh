#!/usr/bin/env bash
set -euo pipefail

THEME_NAME="VS Code Modern Islands"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

MODE="copy"
VAULT_PATH=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [--copy | --symlink] <path-to-obsidian-vault>

Installs "${THEME_NAME}" into <vault>/.obsidian/themes/${THEME_NAME}/

Options:
  --copy      Copy manifest.json and theme.css into the vault (default)
  --symlink   Symlink manifest.json and theme.css for live theme development
  -h, --help  Show this help message
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --copy)
      MODE="copy"
      shift
      ;;
    --symlink)
      MODE="symlink"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -*)
      echo "Error: Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
    *)
      if [[ -n "$VAULT_PATH" ]]; then
        echo "Error: Multiple vault paths provided." >&2
        usage >&2
        exit 1
      fi
      VAULT_PATH="$1"
      shift
      ;;
  esac
done

if [[ -z "$VAULT_PATH" ]]; then
  echo "Error: Please provide the path to your Obsidian vault." >&2
  usage >&2
  exit 1
fi

if [[ ! -d "$VAULT_PATH" ]]; then
  echo "Error: Vault directory does not exist: $VAULT_PATH" >&2
  exit 1
fi

THEMES_DIR="${VAULT_PATH}/.obsidian/themes"
TARGET_DIR="${THEMES_DIR}/${THEME_NAME}"

mkdir -p "$TARGET_DIR"

if [[ "$MODE" == "symlink" ]]; then
  ln -sfn "${REPO_DIR}/manifest.json" "${TARGET_DIR}/manifest.json"
  ln -sfn "${REPO_DIR}/theme.css" "${TARGET_DIR}/theme.css"
  echo "Symlinked '${THEME_NAME}' into: ${TARGET_DIR}"
else
  cp "${REPO_DIR}/manifest.json" "${TARGET_DIR}/manifest.json"
  cp "${REPO_DIR}/theme.css" "${TARGET_DIR}/theme.css"
  echo "Copied '${THEME_NAME}' into: ${TARGET_DIR}"
fi

echo "Next step: Open Obsidian -> Settings -> Appearance -> Themes -> select '${THEME_NAME}'."
