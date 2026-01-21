#!/bin/bash

# Script to check which ports are in use
# Usage: ./scripts/check-ports.sh

echo "🔍 Checking port usage..."
echo ""

# Check common ports
PORTS=(80 443 3000 3001 8080 8443)

for port in "${PORTS[@]}"; do
  if command -v netstat >/dev/null 2>&1; then
    if netstat -tuln 2>/dev/null | grep -q ":$port "; then
      echo "⚠️  Port $port is in use"
      netstat -tuln 2>/dev/null | grep ":$port " | head -1
    else
      echo "✅ Port $port is available"
    fi
  elif command -v ss >/dev/null 2>&1; then
    if ss -tuln 2>/dev/null | grep -q ":$port "; then
      echo "⚠️  Port $port is in use"
      ss -tuln 2>/dev/null | grep ":$port " | head -1
    else
      echo "✅ Port $port is available"
    fi
  elif command -v lsof >/dev/null 2>&1; then
    if lsof -i :$port >/dev/null 2>&1; then
      echo "⚠️  Port $port is in use"
      lsof -i :$port 2>/dev/null | head -2
    else
      echo "✅ Port $port is available"
    fi
  else
    echo "❌ Cannot check ports: netstat, ss, or lsof not found"
    exit 1
  fi
done

echo ""
echo "💡 Tip: If port 80 is in use, set NGINX_HTTP_PORT environment variable:"
echo "   export NGINX_HTTP_PORT=8080"
echo "   docker compose -f infra/docker/docker-compose.prod.yml up -d"
