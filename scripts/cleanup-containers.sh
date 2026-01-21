#!/bin/bash
set -e

# Script to clean up Docker containers and volumes
# Usage: ./scripts/cleanup-containers.sh [dev|staging|prod|all]

ENV=${1:-all}

echo "🧹 Cleaning up Docker containers..."

case $ENV in
  dev)
    echo "Stopping and removing development containers..."
    docker compose -f infra/docker/docker-compose.dev.yml down -v
    docker rm -f portfolio-backend-dev portfolio-frontend-dev 2>/dev/null || true
    ;;
  staging)
    echo "Stopping and removing staging containers..."
    docker compose -f infra/docker/docker-compose.staging.yml down -v
    docker rm -f portfolio-backend-staging portfolio-frontend-staging portfolio-nginx-staging 2>/dev/null || true
    ;;
  prod)
    echo "Stopping and removing production containers..."
    docker compose -f infra/docker/docker-compose.prod.yml down -v
    docker rm -f portfolio-backend-prod portfolio-frontend-prod portfolio-nginx-prod 2>/dev/null || true
    ;;
  all)
    echo "Stopping and removing all containers..."
    docker compose -f infra/docker/docker-compose.dev.yml down -v 2>/dev/null || true
    docker compose -f infra/docker/docker-compose.staging.yml down -v 2>/dev/null || true
    docker compose -f infra/docker/docker-compose.prod.yml down -v 2>/dev/null || true
    
    # Remove any remaining containers by name
    docker rm -f portfolio-backend-dev portfolio-frontend-dev \
                 portfolio-backend-staging portfolio-frontend-staging portfolio-nginx-staging \
                 portfolio-backend-prod portfolio-frontend-prod portfolio-nginx-prod 2>/dev/null || true
    ;;
  *)
    echo "Usage: $0 [dev|staging|prod|all]"
    exit 1
    ;;
esac

echo "✅ Cleanup complete!"
echo ""
echo "You can now run:"
echo "  cd infra/docker"
echo "  docker compose -f docker-compose.dev.yml up --build"
