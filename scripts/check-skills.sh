#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skills_dir="$repo_root/skills"

if [[ ! -d "$skills_dir" ]]; then
  echo "Missing skills/ directory"
  exit 1
fi

found=0
while IFS= read -r -d '' skill_md; do
  found=1
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"

  if ! grep -Eq '^---$' "$skill_md"; then
    echo "$skill_name: missing YAML frontmatter"
    exit 1
  fi

  if ! grep -Eq '^name:[[:space:]]*[^[:space:]]+' "$skill_md"; then
    echo "$skill_name: missing frontmatter name"
    exit 1
  fi

  if ! grep -Eq '^description:[[:space:]]*.+' "$skill_md"; then
    echo "$skill_name: missing frontmatter description"
    exit 1
  fi

  declared_name="$(awk -F': *' '/^name:/ { print $2; exit }' "$skill_md")"
  declared_name="${declared_name//\"/}"
  declared_name="${declared_name//\'/}"
  if [[ "$declared_name" != "$skill_name" ]]; then
    echo "$skill_name: frontmatter name must match folder name ($declared_name)"
    exit 1
  fi

  openai_yaml="$skill_dir/agents/openai.yaml"
  if [[ -f "$openai_yaml" ]]; then
    for key in display_name short_description default_prompt; do
      if ! grep -Eq "^$key:[[:space:]]*.+" "$openai_yaml" && ! grep -Eq "^[[:space:]]+$key:[[:space:]]*.+" "$openai_yaml"; then
        echo "$skill_name: agents/openai.yaml missing $key"
        exit 1
      fi
    done
  fi
done < <(find "$skills_dir" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)

if [[ "$found" -eq 0 ]]; then
  echo "No skills found under skills/"
  exit 1
fi

echo "Skill checks passed"
