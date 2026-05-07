#!/usr/bin/env bash

set -euo pipefail

scope="${1:-$(date +%Y-%m-%d)}"
author="${GITHUB_PR_AUTHOR:-@me}"
state="${GITHUB_PR_STATE:-all}"

gh pr list \
  --author "$author" \
  --state "$state" \
  --search "created:$scope" \
  --json number,title,state,mergedAt \
  --jq '.[] | [.number, .title, (if .mergedAt then "MERGED" else .state end)] | @tsv' |
while IFS=$'\t' read -r pr title pr_state; do
  [ -n "$pr" ] || continue

  printf '\n[%s] PR #%s %s\n\n' "$pr_state" "$pr" "$title"
  gh pr diff "$pr"
  printf '\n'
done