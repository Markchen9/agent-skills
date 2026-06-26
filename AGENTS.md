# Repository Instructions

This repository stores public Codex skills.

## Communication

When reporting results to the owner, use simple and direct language. Avoid code-heavy explanations unless the owner asks for details.

## Before changing skills

- Read the target skill's `SKILL.md` first.
- Keep each skill self-contained.
- Prefer concise guidance over long essays.
- Put long reference material in `references/`.
- Put repeatable commands in `scripts/`.
- Put reusable templates or media in `assets/`.

## Validation

Before reporting completion, run:

```bash
./scripts/check-skills.sh
```

If you changed shell scripts, run the affected script with a safe test input.

## Git hygiene

- Do not commit private tokens, local-only paths, browser profiles, or personal account secrets.
- Keep changes focused.
- Update `CHANGELOG.md` when the public skill behavior changes.
