#!/bin/bash
set -e

# Script to test nginx configuration
# Usage: ./scripts/test-nginx-config.sh [prod|staging|dev]

ENV=${1:-prod}
CONFIG_FILE=""

case $ENV in
  prod)
    CONFIG_FILE="infra/nginx/nginx.prod.conf"
    ;;
  staging)
    CONFIG_FILE="infra/nginx/nginx.staging.conf"
    ;;
  dev)
    CONFIG_FILE="infra/nginx/nginx.dev.conf"
    ;;
  *)
    echo "Usage: $0 [prod|staging|dev]"
    exit 1
    ;;
esac

echo "Testing nginx configuration: $CONFIG_FILE"
echo ""

# Test using nginx in a temporary container
docker run --rm \
  -v "$(pwd)/$CONFIG_FILE:/etc/nginx/conf.d/default.conf:ro" \
  nginx:alpine \
  nginx -t

if [ $? -eq 0 ]; then
  echo ""
  echo "✅ Nginx configuration is valid!"
else
  echo ""
  echo "❌ Nginx configuration has errors!"
  exit 1
fi
