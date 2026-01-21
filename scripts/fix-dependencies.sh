#!/bin/bash
set -e

# Script to fix package-lock.json sync issues
# This regenerates package-lock.json files after adding overrides or updating dependencies

echo "🔧 Fixing package-lock.json files..."

# Fix frontend dependencies
echo ""
echo "📦 Fixing frontend dependencies..."
cd frontend
if [ -f "package-lock.json" ]; then
  echo "Removing old package-lock.json..."
  rm package-lock.json
fi
echo "Running npm install to regenerate package-lock.json..."
npm install
echo "✅ Frontend package-lock.json regenerated"

# Fix backend dependencies
echo ""
echo "📦 Fixing backend dependencies..."
cd ../backend
if [ -f "package-lock.json" ]; then
  echo "Removing old package-lock.json..."
  rm package-lock.json
fi
echo "Running npm install to regenerate package-lock.json..."
npm install
echo "✅ Backend package-lock.json regenerated"

cd ..
echo ""
echo "✅ All package-lock.json files have been regenerated!"
echo ""
echo "You can now run:"
echo "  docker compose -f docker-compose.dev.yml up --build"
