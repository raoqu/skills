#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
  cat <<'EOF'
Usage:
  ./install.sh <skill-dir>

Example:
  ./install.sh analyze-open-source-project
EOF
}

if [[ $# -ne 1 ]]; then
  usage
  exit 1
fi

SKILL_NAME="$1"
SOURCE_DIR="${SCRIPT_DIR}/${SKILL_NAME}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Skill directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

if [[ ! -f "${SOURCE_DIR}/SKILL.md" ]]; then
  echo "Invalid skill directory, missing SKILL.md: ${SOURCE_DIR}" >&2
  exit 1
fi

CODEX_SKILLS_DIR="${CODEX_HOME:-${HOME}/.codex}/skills"
WINDSURF_SKILLS_DIR="${HOME}/.codeium/windsurf/skills"

install_skill() {
  local destination_root="$1"
  local destination_dir="${destination_root}/${SKILL_NAME}"

  mkdir -p "${destination_root}"
  rm -rf "${destination_dir}"

  if command -v rsync >/dev/null 2>&1; then
    rsync -a "${SOURCE_DIR}/" "${destination_dir}/"
  else
    mkdir -p "${destination_dir}"
    cp -R "${SOURCE_DIR}/." "${destination_dir}/"
  fi

  echo "Installed ${SKILL_NAME} -> ${destination_dir}"
}

install_skill "${CODEX_SKILLS_DIR}"
install_skill "${WINDSURF_SKILLS_DIR}"
