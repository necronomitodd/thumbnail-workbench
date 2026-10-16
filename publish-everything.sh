#!/bin/bash
set -e

echo "===================================================================="
echo " THUMBNAIL WORKBENCH - MASTER BUILD, PACKAGE & DEPLOY PIPELINE"
echo "===================================================================="

# 1. Ask for your Gumroad URL slug and update the landing page code
echo ""
read -p "Paste your Gumroad product URL (e.g. https://toddler253.gumroad.com/l/thumbnail-workbench): " GUMROAD_URL

if [ -n "$GUMROAD_URL" ]; then
  echo "-> Injecting Gumroad URL ($GUMROAD_URL) into landing pages..."
  sed -i '' "s|const GUMROAD_PRODUCT_URL = \".*\";|const GUMROAD_PRODUCT_URL = \"$GUMROAD_URL\";|g" Storefront/index.html
  sed -i '' "s|const GUMROAD_PRODUCT_URL = \".*\";|const GUMROAD_PRODUCT_URL = \"$GUMROAD_URL\";|g" docs/index.html
  sed -i '' "s|href=\"https://.*gumroad.com/l/.*\"|href=\"${GUMROAD_URL}?wanted=true\&price=5\"|g" Storefront/index.html
  sed -i '' "s|href=\"https://.*gumroad.com/l/.*\"|href=\"${GUMROAD_URL}?wanted=true\&price=5\"|g" docs/index.html
fi

# 2. Rebuild Universal macOS (.dmg) and Windows (.exe) installers with the new In-App badge
echo ""
echo "-> Rebuilding macOS and Windows desktop installers..."
npm run build:all

# 3. Copy updated binaries into Releases/ and Storefront/ and repack the .zip archive
echo ""
echo "-> Updating Releases/ and Storefront/ packages..."
mkdir -p Releases Storefront

cp src-tauri/target/universal-apple-darwin/release/bundle/dmg/thumbnail-workbench_0.1.0_universal.dmg Releases/
cp src-tauri/target/x86_64-pc-windows-msvc/release/bundle/nsis/thumbnail-workbench_0.1.0_x64-setup.exe Releases/
cp src-tauri/target/x86_64-pc-windows-msvc/release/thumbnail-workbench.exe Releases/thumbnail-workbench_0.1.0_x64-portable.exe

cp Releases/* Storefront/

zip -j Storefront/Thumbnail-Workbench-v0.1.0-All-Platforms.zip \
  Storefront/README_FIRST_INSTALLATION_GUIDE.txt \
  Storefront/thumbnail-workbench_0.1.0_universal.dmg \
  Storefront/thumbnail-workbench_0.1.0_x64-setup.exe \
  Storefront/thumbnail-workbench_0.1.0_x64-portable.exe

# 4. Run the GitHub Pages deployment script
echo ""
echo "-> Deploying code and landing page to GitHub (@necronomitodd)..."
./deploy-live.sh
