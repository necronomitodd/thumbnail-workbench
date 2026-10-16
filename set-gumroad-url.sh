#!/bin/bash
# Usage: ./set-gumroad-url.sh "https://yourname.gumroad.com/l/thumbnail-workbench"

if [ -z "$1" ]; then
  echo "Usage: ./set-gumroad-url.sh <YOUR_GUMROAD_PRODUCT_URL>"
  exit 1
fi

NEW_URL="$1"

# Use sed to replace the GUMROAD_PRODUCT_URL constant in both HTML files
sed -i '' "s|const GUMROAD_PRODUCT_URL = \".*\";|const GUMROAD_PRODUCT_URL = \"$NEW_URL\";|g" Storefront/index.html
sed -i '' "s|const GUMROAD_PRODUCT_URL = \".*\";|const GUMROAD_PRODUCT_URL = \"$NEW_URL\";|g" docs/index.html

echo "Updated GUMROAD_PRODUCT_URL to: $NEW_URL"
