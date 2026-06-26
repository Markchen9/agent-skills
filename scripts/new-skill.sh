#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <skill-name>"
  exit 1
fi

skill_name="$1"
if [[ ! "$skill_name" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
  echo "Skill name must use lowercase letters, numbers, and hyphens"
  exit 1
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
target="$repo_root/skills/$skill_name"

if [[ -e "$target" ]]; then
  echo "Skill already exists: $skill_name"
  exit 1
fi

mkdir -p "$target"
cp -R "$repo_root/templates/skill/." "$target/"

perl -0pi -e "s/name: example-skill/name: $skill_name/" "$target/SKILL.md"
perl -0pi -e "s/# Example Skill/# ${skill_name}/" "$target/SKILL.md"

echo "Created skills/$skill_name"
