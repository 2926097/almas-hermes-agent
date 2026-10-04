#!/usr/bin/env bash
# Create the public GitHub repo from this curated template after confirmation.
set -euo pipefail
repo_name="almas-hermes-agent"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$repo_dir"

if ! command -v gh >/dev/null 2>&1; then
  printf 'GitHub CLI (gh) is not installed in this environment.\n' >&2
  exit 2
fi
if ! gh auth status >/dev/null 2>&1; then
  printf 'Authenticate first with: gh auth login --hostname github.com --git-protocol https --web\n' >&2
  exit 3
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git init -b main
fi

# Stage only reviewed public-template files; never stage the whole directory.
git add -- README.md SOUL.md .gitignore publish.sh setup-and-publish.sh
if git diff --cached --quiet; then
  printf 'No curated files staged for the initial publication.\n' >&2
  exit 4
fi

printf '\nFiles that would be included in the PUBLIC repository:\n'
git --no-pager diff --cached --stat
printf '\nReview the complete diff before continuing:\n'
git --no-pager diff --cached
printf '\n'
read -r -p 'Create the PUBLIC GitHub repository almas-hermes-agent and push these files? [y/N] ' answer
case "$answer" in
  y|Y|yes|YES) ;;
  *) git reset --quiet -- README.md SOUL.md .gitignore publish.sh setup-and-publish.sh; printf 'Cancelled; no repository created.\n'; exit 0 ;;
esac

# Refuse to accidentally publish this template to an unrelated existing origin.
if git remote get-url origin >/dev/null 2>&1; then
  login="$(gh api user --jq .login)"
  origin="$(git remote get-url origin)"
  case "$origin" in
    "https://github.com/$login/$repo_name"|"https://github.com/$login/$repo_name.git"|"git@github.com:$login/$repo_name"|"git@github.com:$login/$repo_name.git"|"ssh://git@github.com/$login/$repo_name"|"ssh://git@github.com/$login/$repo_name.git") ;;
    *) printf 'Refusing to push: origin is not the intended repository (%s).\n' "$origin" >&2; exit 6 ;;
  esac
fi

if ! git config user.name >/dev/null || ! git config user.email >/dev/null; then
  printf 'Set your Git commit identity first: git config --global user.name / user.email\n' >&2
  exit 5
fi

git commit -m 'Initial ALMAS agent template'
if git remote get-url origin >/dev/null 2>&1; then
  printf 'The target origin already exists; pushing there.\n'
  git push -u origin main
else
  gh repo create "$repo_name" --public --source . --remote origin --push
fi

printf '\nRepository verification:\n'
gh repo view "$repo_name" --json name,url,visibility,defaultBranchRef --jq '{name,url,visibility,defaultBranch:.defaultBranchRef.name}'
