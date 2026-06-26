---
name: claude-delegate
description: Prepare a detailed manual prompt or handoff file for Claude Code or a compatible coding agent without invoking that agent directly. Use only when the user explicitly asks Codex to hand work to Claude Code, asks what another agent should do, asks for a Claude/agent prompt, says 写提示词, 交给 Claude Code, 复制给 Claude, 让 Claude Code 做什么, or invokes claude-delegate/manual worker mode. Do not use merely because a task mentions Claude while asking Codex to do the work itself.
---

# Claude Delegate

Use this skill to prepare a copy-ready prompt or durable handoff file that the
user will give to Claude Code or another compatible coding agent. Codex remains
the planner and handoff author. Codex must not start `claude`, `claude -p`,
`claude --continue`, or any other agent CLI command under this skill.

The output must be concrete enough for a fresh agent to execute without
re-deciding the goal, scope, commands, verification, or stop conditions.

## Non-Negotiables

- Confirm the user explicitly asked to involve Claude Code or another agent.
- Do not invoke the target agent from Codex.
- Keep the handoff scoped to the user's requested task.
- Do not add unrelated cleanup, refactors, tests, or repositories.
- Do not duplicate content already captured in PRDs, plans, ADRs, issues,
  commits, diffs, or logs. Reference them by path or URL and extract only the
  facts needed for execution.
- Redact secrets, credentials, tokens, passwords, private keys, personal
  identifiers, and private machine/account details unless the user explicitly
  says they are safe to include.

## Context Gathering

Before writing the prompt or handoff:

- Read the user-referenced files, issues, PRDs, plans, ADRs, logs, screenshots,
  diffs, docs, or prior handoff files when they are available.
- Discover current project instructions instead of hard-coding project rules.
  Check relevant files such as `AGENTS.md`, `CLAUDE.md`, `.claude/rules/*`,
  `.cursor/rules/*`, `.github/copilot-instructions.md`, README files, local
  issue trackers, and docs only when they exist and are relevant.
- Include project instructions in the handoff only when they affect the
  delegated task. Cite their paths.
- Identify current state from actual artifacts, not memory: changed files,
  failing commands, open questions, known constraints, and prior decisions.
- If a required path, command, environment, credential, remote system, or
  approval is unknown, either make the uncertainty explicit as a stop condition
  or ask the user before producing a write or execution handoff.

## Output Mode Decision

Default to prompt-only mode. Use handoff-file mode when durable context or
structured execution matters.

Before writing the final response, choose exactly one output mode and complete
its required artifact. If any handoff-file trigger below is true, creating the
handoff file is part of the task; do not replace it with an in-chat summary or
path suggestion.

Use prompt-only mode when all of these are true:

- The task is a short one-off request.
- The full context fits comfortably in the response.
- The task is analysis-only or edits a small explicit set of files.
- No external state, deployment, remote environment, elevated privilege,
  destructive command, or multi-machine workflow is involved.
- The user did not ask to record a handoff, preserve context, or prepare a
  continuation artifact.

Use handoff-file mode when any of these are true:

- The user asks for `handoff`, `交接`, `记录下来`, `沉淀`, or a durable
  continuation artifact.
- The task spans multiple modules, repositories, services, or agents.
- The task has multiple phases, gates, approvals, or verification steps.
- The task depends on existing PRDs, issues, ADRs, plans, commits, diffs, logs,
  screenshots, or prior decisions.
- The task involves external state such as remote systems, production data,
  deployment, publishing, credentials, billing, package installation, hardware,
  privileged commands, or destructive actions.
- The prompt would be too long or fragile to paste directly.
- Another agent/session may need to continue the work later.

If the user explicitly asks for "just a prompt", prefer prompt-only mode unless
that would make the delegation unsafe or ambiguous.

## Prompt-Only Mode

Return one copy-ready fenced prompt. Keep it self-contained and concrete. Use
this shape and do not omit fields:

```text
Working directory:
Task mode:
Objective:
Current state:
Source artifacts:
Required reading:
Assumptions:
Allowed inspection:
Allowed edits:
Allowed commands:
Forbidden actions:
Execution steps:
Verification:
Stop conditions:
Expected report:
Suggested skills:
```

If a field does not apply, write `None` and explain why on the same line.

## Handoff-File Mode

Create a Markdown file under the current workspace:

```text
.scratch/handoff/<yyyy-mm-dd>-<topic>-claude.md
```

Create `.scratch/handoff/` if it does not exist. Use lowercase hyphenated
English topics where practical. Do not overwrite an existing handoff unless the
user explicitly asks to update it. If the target file already exists, append
`-v2`, `-v3`, or a more specific topic. If the workspace is unavailable or not
writable, stop and ask where to save the handoff.

Use this structure and do not omit sections:

```text
# <Task Title>

## Objective
## Current State
## Source Artifacts
## Required Reading
## Assumptions
## Allowed Inspection
## Allowed Edits
## Allowed Commands
## Forbidden Actions
## Execution Steps
## Verification
## Stop Conditions
## Expected Report
## Suggested Skills
```

After creating the file, return a short copy-ready prompt telling Claude Code
or the target agent to read and execute the handoff. Include the workspace path
and handoff file path.

Completion gate: before reporting that a handoff file is ready, verify the file
exists under `.scratch/handoff/`, is non-empty, and contains every required
section listed above. If a resume, context compaction, interruption, or tool
failure happens before this verification, continue by checking whether the file
was actually created; if not, create it before giving the final response. Never
describe a proposed handoff filename as if it already exists.

## Handoff Content Contract

Every prompt or handoff must state:

- The working directory or workspace.
- The task mode: `analysis-only`, `write`, or `execution/test`.
- The exact objective and non-goals.
- What is known about current state, including relevant failures or partial
  work.
- Source artifacts to read, with paths or URLs.
- Project instructions or policy files that affect the task.
- Assumptions the agent may rely on.
- Files, directories, URLs, logs, or commands the agent may inspect.
- Files or directories the agent may edit, if any.
- Commands the agent may run, if any.
- Actions the agent must not take.
- Ordered execution steps.
- Verification commands and manual acceptance checks.
- Stop conditions for missing scope, failed gates, unsafe state, or required
  approval.
- Expected final report format.
- Suggested skills the next agent should invoke, if any.

For long source artifacts, summarize only the execution-relevant facts and
link to the source. Do not paste large artifacts into the handoff.

## Scope and Safety Rules

- Allowed inspection may be broader than allowed edits, but it must be relevant
  to the task.
- Allowed edits must be explicit files or narrow directories for write prompts.
- Do not allow broad edit roots, generated build trees, dependency directories,
  credentials, or unrelated repositories unless the user explicitly approves
  that scope.
- Do not permit `git add`, `git commit`, `git push`, history rewriting,
  destructive checkout/reset/restore, deployment, publishing, package
  installation, credential edits, billing changes, or privileged commands unless
  the user explicitly requested them and the handoff names the exact command or
  gate.
- If more scope is needed, tell the target agent to stop and report the needed
  paths, commands, approvals, or credentials instead of guessing.
- If project instructions conflict with the user's delegation request, state
  the conflict in the handoff and require the target agent to stop unless the
  user resolves it.

## Concrete Execution Requirements

For analysis-only delegation:

- Tell the target agent not to edit files.
- Require findings first, ordered by severity or decision impact.
- Require file paths, line numbers, command outputs, screenshots, or URLs as
  evidence when applicable.
- Separate true issues from non-issues, assumptions, and recommended follow-up.

For write delegation:

- Require the target agent to record pre-change status.
- Require edits only inside the named allowed edit paths.
- Require preservation of unrelated local changes.
- Require verification before reporting success.
- Require a report of changed files, commands run, results, and residual risks.

For execution/test delegation:

- Require exact gates and commands.
- Require the target agent to stop after a failed or blocked gate.
- Prefer checkpoint markers:

```text
[DELEGATE] START <gate>
[DELEGATE] PASS <gate>
[DELEGATE] FAIL <gate>: <reason>
[DELEGATE] BLOCKED <gate>: <needed info or approval>
```

## Final Response

- For prompt-only mode, return the copy-ready fenced prompt directly.
- For handoff-file mode, give the handoff file path and a concise summary, then
  return the short copy-ready prompt that tells the target agent to read the
  file.
- Do not claim the delegated work is complete. Only claim the prompt or handoff
  artifact is ready.
