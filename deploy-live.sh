#!/bin/bash
set -e

# Ensure Homebrew bin is in PATH so 'gh' is always found
export PATH="/opt/homebrew/bin:$PATH"

REPO_NAME="thumbnail-workbench"

git add .
git commit -m "Update store links and app release files" || true

if ! gh auth status >/dev/null 2>&1; then
  echo "-> Launching one-click browser authentication for GitHub (@necronomitodd)..."
  gh auth login -p https -w
fi

GH_USER=$(gh api user -q ".login")

if ! git remote get-url origin >/dev/null 2>&1; then
  echo "-> Creating public GitHub repository https://github.com/$GH_USER/$REPO_NAME ..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
else
  echo "-> Pushing latest changes to https://github.com/$GH_USER/$REPO_NAME ..."
  git push -u origin main
fi

echo "-> Activating GitHub Pages on /docs..."
gh api --method POST -H "Accept: application/vnd.github+json" "/repos/$GH_USER/$REPO_NAME/pages" \
  -f "source[branch]=main" -f "source[path]=/docs" 2>/dev/null || \
gh api --method PUT -H "Accept: application/vnd.github+json" "/repos/$GH_USER/$REPO_NAME/pages" \
  -f "source[branch]=main" -f "source[path]=/docs" >/dev/null 2>&1 || true

echo ""
echo "===================================================================="
echo " SUCCESS! Your live web page is deploying to:"
echo " https://${GH_USER}.github.io/${REPO_NAME}/"
echo "===================================================================="
