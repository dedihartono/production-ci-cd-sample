#!/bin/bash
set -e

# Smoke tests for post-deployment verification
# Usage: ./scripts/smoke-tests.sh <environment_url>

ENV_URL=${1:-http://localhost}

echo "Running smoke tests against: $ENV_URL"

# Test health endpoint
echo "Testing health endpoint..."
curl -f "${ENV_URL}/health" || {
  echo "Health check failed!"
  exit 1
}

# Test API endpoint
echo "Testing API endpoint..."
curl -f "${ENV_URL}/api/portfolio" || {
  echo "API check failed!"
  exit 1
}

# Test frontend
echo "Testing frontend..."
curl -f "${ENV_URL}/" || {
  echo "Frontend check failed!"
  exit 1
}

# Test specific project endpoint
echo "Testing project endpoint..."
curl -f "${ENV_URL}/api/portfolio/projects/1" || {
  echo "Project endpoint check failed!"
  exit 1
}

echo "All smoke tests passed!"
