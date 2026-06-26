---
name: skill-repository
description: Use when creating, organizing, validating, publishing, or versioning a public GitHub repository of agent skills for Claude Code, Codex, or compatible coding agents.
metadata:
  author: Markchen9
  version: "0.1.0"
---

# Skill Repository

Use this skill when the task is to manage a public collection of agent skills in GitHub.

## Success criteria

A skill repository is ready when:

- Each skill has its own folder under `skills/`.
- Every skill folder has a valid `SKILL.md` with `name` and `description`.
- Optional support files live in predictable folders: `agents/`, `references/`, `scripts/`, or `assets/`.
- The root `README.md` explains install, creation, validation, and release flow.
- `scripts/check-skills.sh` passes before changes are published.

## Workflow

1. Inspect the current repository shape with `rg --files`.
2. Read the skill being changed before editing it.
3. Keep `SKILL.md` concise and move detailed reusable knowledge into `references/`.
4. Update `agents/openai.yaml` if the skill's public-facing name or prompt changes.
5. Run `./scripts/check-skills.sh`.
6. Commit focused changes and push to GitHub.
7. For public releases, tag a version such as `v0.1.0`.

## Folder conventions

```text
skills/<skill-name>/
├── SKILL.md
├── agents/openai.yaml
├── references/
├── scripts/
└── assets/
```

Only create optional folders when they are useful.

## Quality bar

- A new user can understand what the skill does from the first screen of `SKILL.md`.
- The trigger description says when to use the skill, not just what it is.
- The body gives procedure and judgment rules, not generic motivation.
- Validation is runnable locally and in GitHub Actions.
