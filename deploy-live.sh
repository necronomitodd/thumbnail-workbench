#!/bin/bash
set -e

REPO_NAME="thumbnail-workbench"
GH_USER="necronomitodd"

echo "-> Preparing Git commit..."
git add .
git commit -m "Update store links and app release files" || true

# Check if remote origin already exists; if not, add it using standard HTTPS URL
if ! git remote get-url origin >/dev/null 2>&1; then
  echo "-> Linking remote repository to https://github.com/$GH_USER/$REPO_NAME.git"
  git remote add origin "https://github.com/$GH_USER/$REPO_NAME.git"
fi

echo "-> Pushing latest code to main branch..."
git branch -M main
git push -u origin main

echo ""
echo "===================================================================="
echo " CODE PUSHED SUCCESSFULLY!"
echo " Next step: Go to https://github.com/$GH_USER/$REPO_NAME/settings/pages"
echo " Set Source to 'Deploy from a branch', select 'main' and '/docs', and save."
echo " Your site will be live at: https://$GH_USER.github.io/$REPO_NAME/"
echo "===================================================================="
