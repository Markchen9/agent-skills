# Agent Skills

Personal skill collection for AI coding agents.

This repository is public so other people can read, copy, install, and improve the skills here. The skills are meant to be useful across agent tools such as Claude Code, Codex, and other compatible coding agents.

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
git clone https://github.com/Markchen9/agent-skills.git
cd agent-skills
```

Install `claude-delegate` into the skills folder used by your agent:

```bash
# Claude Code or compatible tools that read ~/.claude/skills
./scripts/install-skill.sh claude-delegate ~/.claude/skills

# Codex
./scripts/install-skill.sh claude-delegate ~/.codex/skills

# VS Code / Copilot agent skills
./scripts/install-skill.sh claude-delegate ~/.copilot/skills

# Other compatible agents
./scripts/install-skill.sh claude-delegate ~/.agents/skills
```

Available skills:

| Skill | Purpose |
| --- | --- |
| `claude-delegate` | Prepare a manual prompt or handoff file for Claude Code or a compatible coding agent. Originally authored by Eric Chen. |
| `skill-repository` | Manage this public skill repository. |

Or copy a skill manually into the folder your agent reads:

```bash
cp -R skills/claude-delegate ~/.claude/skills/
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

## Compatibility

The shared skill format is a folder with `SKILL.md` and optional supporting files. Different agents may read skills from different directories, so install the folder into the location required by your tool.

Common locations:

| Tool | Typical personal skill folder |
| --- | --- |
| Claude Code / Claude-compatible tools | `~/.claude/skills/` |
| Codex | `~/.codex/skills/` |
| VS Code / Copilot | `~/.copilot/skills/` or `~/.agents/skills/` |

Project-local skills are commonly stored in folders such as `.claude/skills/`, `.agents/skills/`, or `.github/skills/`, depending on the tool.

## License

MIT

See `NOTICE.md` for third-party authorship notes.
