#!/bin/bash
set -e

# Security scanning script
# Scans for package vulnerabilities, secrets, and code issues

echo "Starting security scan..."

# Package vulnerability scanning
echo "Scanning backend packages..."
cd backend
if npm audit --audit-level=moderate; then
  echo "✅ Backend: No moderate or high severity vulnerabilities found"
else
  echo "⚠️  Backend: Vulnerabilities found (check output above)"
  echo "Note: Some vulnerabilities may be in transitive dependencies"
  echo "Run 'npm audit fix' to attempt automatic fixes"
fi

echo ""
echo "Scanning frontend packages..."
cd ../frontend
if npm audit --audit-level=moderate; then
  echo "✅ Frontend: No moderate or high severity vulnerabilities found"
else
  echo "⚠️  Frontend: Vulnerabilities found (check output above)"
  echo "Note: Vulnerabilities in react-scripts dependencies are handled via package.json overrides"
  echo "Run 'npm install' to apply overrides, then 'npm audit' to verify"
fi

cd ..

# Check for .env files in git
echo "Checking for committed .env files..."
if git ls-files | grep -q "\.env$"; then
  echo "WARNING: .env files found in repository!"
  git ls-files | grep "\.env$"
  exit 1
fi

# Check for common secret patterns (basic check)
echo "Checking for potential secrets..."
if grep -r "password.*=.*['\"].*[a-zA-Z0-9]{8,}" --include="*.js" --include="*.jsx" backend/ frontend/ 2>/dev/null; then
  echo "WARNING: Potential hardcoded passwords found!"
  exit 1
fi

echo "Security scan completed!"
