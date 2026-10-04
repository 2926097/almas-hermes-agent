#!/usr/bin/env bash
# Preview, confirm, and publish the curated public template.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if ! git remote get-url origin >/dev/null 2>&1; then
  printf 'No origin remote configured. Set up the GitHub repository first.\n' >&2
  exit 2
fi

# Deliberately stage only this public allowlist, never the whole working tree.
git add -- README.md SOUL.md .gitignore
if git diff --cached --quiet; then
  printf 'No curated-file changes to publish.\n'
  exit 0
fi

printf '\nProposed public changes:\n'
git --no-pager diff --cached --stat
printf '\n'
git --no-pager diff --cached
printf '\n'
read -r -p 'Commit and push these changes to the PUBLIC GitHub repository? [y/N] ' answer
case "$answer" in
  y|Y|yes|YES)
    git commit -m "Update ALMAS agent template"
    git push
    ;;
  *)
    git reset --quiet -- README.md SOUL.md .gitignore
    printf 'Cancelled; nothing published.\n'
    ;;
esac
