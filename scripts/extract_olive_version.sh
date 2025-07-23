#!/bin/bash
set -e

echo "════════════════════════════════════════════════════════════════════════════════"
echo "📦 STEP 9: OLIVE CLI Version Extraction"
echo "════════════════════════════════════════════════════════════════════════════════"
echo "🔍 Extracting Olive CLI version..."
OLIVE_VERSION=$(olive-cli --version 2>&1 | head -n1 | sed 's/^[[:space:]]*//' | sed 's/[[:space:]]*$//')
if [[ $OLIVE_VERSION == *"Unable to find"* ]] || [[ $OLIVE_VERSION == *"Error"* ]]; then
  OLIVE_VERSION="Version information unavailable"
fi

if [ -n "$GITHUB_OUTPUT" ] && [ -f "$GITHUB_OUTPUT" ]; then
  echo "version=$OLIVE_VERSION" >> $GITHUB_OUTPUT
else
  echo "::set-output name=version::$OLIVE_VERSION"
fi

mkdir -p /home/deploy/repository/.olive/1
echo "$OLIVE_VERSION" > /home/deploy/repository/.olive/1/olive_version.txt

echo "📦 Olive CLI Version: $OLIVE_VERSION"

echo "════════════════════════════════════════════════════════════════════════════════"
echo "✅ OLIVE CLI Version Extraction Complete"
echo "════════════════════════════════════════════════════════════════════════════════"
echo "" 