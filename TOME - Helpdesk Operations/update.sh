#!/usr/bin/env bash
# TOME Platform Updater
# Fetches the full repo tree from GitHub and downloads everything that isn't
# user data. New platform files in future versions are picked up automatically.
# Usage: bash update.sh [--force]

set -euo pipefail

REPO="super-gill/tome.md"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"
TREE_URL="https://api.github.com/repos/${REPO}/git/trees/${BRANCH}?recursive=1"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# User data — these paths are NEVER overwritten.
# Everything else in the repo is considered platform and will be updated.
PROTECTED=(
  "Books/"
  "tome.json"
  "export-branding/"
)

FORCE=false
[[ "${1:-}" == "--force" ]] && FORCE=true

# --- Helpers ---

log()  { printf "\033[1;34m[TOME]\033[0m %s\n" "$1"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$1"; }
err()  { printf "\033[1;31m[ERR]\033[0m %s\n" "$1" >&2; }

download() {
  local url="$1" dest="$2"
  if command -v curl &>/dev/null; then
    curl -fsSL "$url" -o "$dest"
  elif command -v wget &>/dev/null; then
    wget -qO "$dest" "$url"
  else
    err "Neither curl nor wget found. Install one and retry."
    exit 1
  fi
}

is_protected() {
  local path="$1"
  for p in "${PROTECTED[@]}"; do
    # Directory rule: protect anything inside it
    if [[ "$p" == */ ]] && [[ "$path" == "${p}"* ]]; then
      return 0
    fi
    # Exact file match
    if [[ "$path" == "$p" ]]; then
      return 0
    fi
  done
  return 1
}

# --- Version check ---

log "Checking for updates..."

TMPDIR_UPDATE=$(mktemp -d)
trap 'rm -rf "$TMPDIR_UPDATE"' EXIT

download "${BASE_URL}/version.json" "${TMPDIR_UPDATE}/version.json" || {
  err "Could not reach GitHub. Check your connection."
  exit 1
}

REMOTE_VERSION=$(grep -oP '"version"\s*:\s*"\K[^"]+' "${TMPDIR_UPDATE}/version.json")
LOCAL_VERSION="(unknown)"
if [[ -f "${SCRIPT_DIR}/version.json" ]]; then
  LOCAL_VERSION=$(grep -oP '"version"\s*:\s*"\K[^"]+' "${SCRIPT_DIR}/version.json")
fi

log "Local:  ${LOCAL_VERSION}"
log "Remote: ${REMOTE_VERSION}"

if [[ "$LOCAL_VERSION" == "$REMOTE_VERSION" ]] && [[ "$FORCE" == false ]]; then
  log "Already up to date. Use --force to re-download anyway."
  exit 0
fi

# --- Fetch repo tree ---

log "Fetching file list from GitHub..."

TREE_FILE="${TMPDIR_UPDATE}/tree.json"
download "$TREE_URL" "$TREE_FILE" || {
  err "Could not fetch repository tree."
  exit 1
}

# Extract file paths (type "blob") from the tree JSON
# Each entry looks like: "path": "libs/markdown-it.min.js", ... "type": "blob"
# We grab all paths, then filter to blobs only via the paired type field.
mapfile -t ALL_FILES < <(
  grep -oP '"path"\s*:\s*"\K[^"]+' "$TREE_FILE"
)

mapfile -t ALL_TYPES < <(
  grep -oP '"type"\s*:\s*"\K[^"]+' "$TREE_FILE"
)

# Build list of platform files to download
PLATFORM_FILES=()
SKIPPED=()

for i in "${!ALL_FILES[@]}"; do
  path="${ALL_FILES[$i]}"
  type="${ALL_TYPES[$i]}"

  # Only download files, not tree entries
  [[ "$type" != "blob" ]] && continue

  if is_protected "$path"; then
    SKIPPED+=("$path")
  else
    PLATFORM_FILES+=("$path")
  fi
done

log "Found ${#PLATFORM_FILES[@]} platform files, ${#SKIPPED[@]} user files protected."

# --- Backup and download ---

BACKUP_DIR="${SCRIPT_DIR}/.update-backup"
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

FAILED=()
UPDATED=0

for file in "${PLATFORM_FILES[@]}"; do
  dest="${SCRIPT_DIR}/${file}"
  dest_dir=$(dirname "$dest")

  # Backup existing file
  if [[ -f "$dest" ]]; then
    backup_path="${BACKUP_DIR}/${file}"
    mkdir -p "$(dirname "$backup_path")"
    cp "$dest" "$backup_path"
  fi

  # Ensure target directory exists
  mkdir -p "$dest_dir"

  log "  ${file}"
  if download "${BASE_URL}/${file}" "$dest"; then
    ((UPDATED++))
  else
    warn "  Failed: ${file}"
    FAILED+=("$file")
  fi
done

# --- Result ---

echo ""
echo "─────────────────────────────────────────"
if [[ ${#FAILED[@]} -gt 0 ]]; then
  printf "\033[1;31m  UPDATE FAILED\033[0m\n"
  echo "─────────────────────────────────────────"
  echo ""
  warn "${UPDATED} files updated, ${#FAILED[@]} failed:"
  for f in "${FAILED[@]}"; do
    err "  ✗ ${f}"
  done
  echo ""
  warn "Previous versions backed up to .update-backup/"
  exit 1
else
  printf "\033[1;32m  UPDATE SUCCESSFUL\033[0m\n"
  echo "─────────────────────────────────────────"
  echo ""
  log "${LOCAL_VERSION} → ${REMOTE_VERSION}  (${UPDATED} files)"
  log "Backup saved to .update-backup/"
fi
