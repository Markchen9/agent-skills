# Codex Skills

Personal skill collection for Codex-style agents.

This repository is public so other people can read, copy, install, and improve the skills here. Each skill is a small folder with a required `SKILL.md` file and optional supporting files.

## Repository layout

```text
.
├── skills/              # Published skills
├── templates/           # Starting point for new skills
├── scripts/             # Local maintenance scripts
└── .github/workflows/   # Checks that run on GitHub
```

## Install a skill

Clone the repository:

```bash
git clone https://github.com/Markchen9/codex-skills.git
cd codex-skills
```

Install one skill into your local Codex skills folder:

```bash
./scripts/install-skill.sh skill-repository ~/.codex/skills
```

Available skills:

| Skill | Purpose |
| --- | --- |
| `claude-delegate` | Prepare a manual prompt or handoff file for Claude Code or a compatible coding agent. |
| `skill-repository` | Manage this public skill repository. |

Or copy a skill manually:

```bash
cp -R skills/skill-repository ~/.codex/skills/
```

## Create a new skill

Use the helper script:

```bash
./scripts/new-skill.sh my-new-skill
```

Then edit:

```text
skills/my-new-skill/SKILL.md
skills/my-new-skill/agents/openai.yaml
```

Before committing, run:

```bash
./scripts/check-skills.sh
```

## Versioning

Use Git tags for releases:

```bash
git tag v0.1.0
git push origin main --tags
```

Keep changes small and describe what changed in `CHANGELOG.md`.

## Skill structure

Minimum:

```text
skills/example-skill/
└── SKILL.md
```

Recommended:

```text
skills/example-skill/
├── SKILL.md
├── agents/
│   └── openai.yaml
├── references/
├── scripts/
└── assets/
```

Use `references/` for longer guidance, `scripts/` for repeatable commands, and `assets/` for templates or media that the skill uses.

## Source archives

`claude-delegate.7z` is kept as the original uploaded archive for `skills/claude-delegate/`.

## License

MIT
