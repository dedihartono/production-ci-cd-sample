#!/bin/bash

# Script to check status of Docker containers
# Usage: ./scripts/check-status.sh [dev|staging|prod]

ENV=${1:-dev}
COMPOSE_FILE=""

case $ENV in
  dev)
    COMPOSE_FILE="infra/docker/docker-compose.dev.yml"
    ;;
  staging)
    COMPOSE_FILE="infra/docker/docker-compose.staging.yml"
    ;;
  prod)
    COMPOSE_FILE="infra/docker/docker-compose.prod.yml"
    ;;
  *)
    echo "Usage: $0 [dev|staging|prod]"
    exit 1
    ;;
esac

echo "📊 Checking status of $ENV environment..."
echo ""

cd "$(dirname "$0")/.." || exit

# Check container status
echo "Container Status:"
docker compose -f "$COMPOSE_FILE" ps
echo ""

# Check health status
echo "Health Status:"
docker compose -f "$COMPOSE_FILE" ps --format json | jq -r '.[] | "\(.Name): \(.Health // "N/A")"' 2>/dev/null || docker compose -f "$COMPOSE_FILE" ps
echo ""

# Check logs (last 10 lines)
echo "Recent Logs (last 10 lines per service):"
docker compose -f "$COMPOSE_FILE" logs --tail=10
echo ""

echo "✅ Status check complete!"
echo ""
echo "To view live logs:"
echo "  docker compose -f $COMPOSE_FILE logs -f"
echo ""
echo "To check specific service:"
echo "  docker compose -f $COMPOSE_FILE logs -f <service-name>"
