---
name: daily-report
description: 'Generate a short daily development report from your own GitHub pull requests. Use when you need 3 candidate report samples based on date PR titles and diffs, grouped by top-level folder with very short bullets.'
metadata:
  version: '0.1'
argument-hint: 'Date or PR scope for the report, for example: today, yesterday, or this week'
---

# Daily Report

## Prerequisites

- `gh` (GitHub CLI) installed and authenticated (`gh auth status` passes)
- Access to the target repositories from the current environment
- Internet access to reach the GitHub API

## When to Use

Use this skill when the user wants a short daily report based on their own GitHub pull requests and the underlying changes.

Typical triggers:

- daily report
- standup report
- summarize my PRs
- report from gh PRs
- 3 report samples

## Inputs

Collect or confirm these inputs before writing the report:

- report scope, such as `today`, `yesterday`, or a date range;
- whether GitHub CLI access is available in the current environment;
- whether merged, open, or all PR states should be included when the user says otherwise.

Default behavior:

- use the current date;
- include the current user's own PRs;
- include all states unless the user asks for a narrower scope.

## Procedure

1. Gather PRs with [collect-prs.sh](./scripts/collect-prs.sh). Pass a date or range only when the user asks for it.
2. Review each PR title and diff together. Do not summarize from the title alone when the diff shows a different main change.
3. Map each PR to one top-level parent folder, such as `backend`, `admin`, or `frontend`.
4. Compress each PR into 1 or 2 short tasks. If the PR is broad, keep only the main point.
5. Split merged PRs into `Complete task` and open or closed-unmerged PRs into `In progress`.
6. Produce exactly 3 candidate report samples.
7. Keep the output format exact:

```text
Sample 1:

Complete task:
[backend]
• task 1
• task 2

In progress:
[admin]
• task 3
```

8. Group bullets by area. Use the top-level parent folder name in square brackets.
9. Keep wording simple. Each bullet must be under 10 words.
10. Avoid repeating the same bullet across samples unless the source PR set is tiny.

## Decision Rules

- If there are no PRs in scope, say that no PRs were found and ask whether to widen the date range.
- If `gh` is unavailable or auth fails, ask the user for pasted PR summaries or diffs.
- If a PR is merged, place it under `Complete task`.
- If a PR is open or closed without merge, place it under `In progress`.
- If a PR touches many folders, group it by the folder that carries the main behavior change.
- If a PR is mostly refactor or cleanup, prefer the user-facing or system-impacting change over mechanical details.
- If one PR contains several small edits in the same area, combine them into one short bullet when possible.

## Output Rules

- Use short bullet points only.
- Group by area using the top-level parent folder name.
- Use simple wording.
- Put merged PRs under `Complete task`.
- Put unmerged PRs under `In progress`.
- Each PR should become at most 1 to 2 bullets.
- If a PR is too big, summarize the main point in 1 or 2 bullets.
- Keep every bullet under 10 words.
- Do not add prose before, between, or after samples unless the user asks.

## Completion Check

Before replying, verify:

- there are exactly 3 samples;
- each sample uses `Sample {num}:`;
- merged PRs only appear under `Complete task`;
- unmerged PRs only appear under `In progress`;
- each area header is `[folder-name]`;
- every line under an area is a bullet;
- no bullet exceeds 9 words;
- no PR is expanded beyond 2 bullets.
