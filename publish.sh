#!/usr/bin/env bash
# Preview, confirm, and publish the curated public template.
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if ! git remote get-url origin >/dev/null 2>&1; then
  printf 'No origin remote configured. Set up the GitHub repository first.\n' >&2
  exit 2
fi

# Deliberately stage only the public distribution allowlist; never stage the whole working tree.
allowed_files=(README.md SOUL.md .gitignore distribution.yaml publish.sh setup-and-publish.sh)
while IFS= read -r -d '' path; do
  case "$path" in
    README.md|SOUL.md|.gitignore|distribution.yaml|publish.sh|setup-and-publish.sh) ;;
    *) printf 'Refusing to publish pre-staged file outside allowlist: %s\n' "$path" >&2; exit 7 ;;
  esac
done < <(git diff --cached --name-only -z)
git add -- "${allowed_files[@]}"
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
    git reset --quiet -- README.md SOUL.md .gitignore distribution.yaml publish.sh setup-and-publish.sh
    printf 'Cancelled; nothing published.\n'
    ;;
esac
