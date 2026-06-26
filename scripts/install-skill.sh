#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 || $# -gt 2 ]]; then
  echo "Usage: $0 <skill-name> [install-dir]"
  exit 1
fi

skill_name="$1"
install_dir="${2:-$HOME/.agent-skills}"
repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/skills/$skill_name"
target_dir="$install_dir/$skill_name"

if [[ ! -d "$source_dir" ]]; then
  echo "Unknown skill: $skill_name"
  exit 1
fi

mkdir -p "$install_dir"
rm -rf "$target_dir"
cp -R "$source_dir" "$target_dir"

echo "Installed $skill_name to $target_dir"
