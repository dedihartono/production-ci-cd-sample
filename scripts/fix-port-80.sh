#!/bin/bash

# Script to fix port 80 conflict and restart nginx on port 80
# Usage: ./scripts/fix-port-80.sh

set -e

echo "🔍 Checking what's using port 80..."

# Check what's using port 80
if command -v lsof >/dev/null 2>&1; then
    echo "Processes using port 80:"
    sudo lsof -i :80 || echo "No processes found (or permission denied)"
elif command -v netstat >/dev/null 2>&1; then
    echo "Processes using port 80:"
    sudo netstat -tulpn | grep :80 || echo "No processes found"
elif command -v ss >/dev/null 2>&1; then
    echo "Processes using port 80:"
    sudo ss -tulpn | grep :80 || echo "No processes found"
fi

echo ""
echo "📋 Options:"
echo "1. Stop the service using port 80 and restart nginx on port 80"
echo "2. Keep current setup (nginx on port 8080)"
echo ""
read -p "Choose option (1 or 2): " choice

if [ "$choice" = "1" ]; then
    echo ""
    echo "🛑 Stopping service on port 80..."
    
    # Try to find and stop the process
    if command -v lsof >/dev/null 2>&1; then
        PID=$(sudo lsof -ti:80 2>/dev/null || echo "")
        if [ -n "$PID" ]; then
            echo "Found process $PID using port 80"
            read -p "Stop this process? (y/n): " confirm
            if [ "$confirm" = "y" ]; then
                sudo kill -9 $PID
                echo "✅ Process stopped"
            fi
        else
            echo "⚠️  Could not find process using port 80"
        fi
    fi
    
    echo ""
    echo "🔄 Restarting nginx container on port 80..."
    cd infra/docker
    
    # Unset NGINX_HTTP_PORT to use default port 80
    unset NGINX_HTTP_PORT
    export NGINX_HTTP_PORT=80
    
    # Restart nginx service
    docker compose -f docker-compose.prod.yml up -d nginx
    
    echo ""
    echo "✅ Nginx should now be running on port 80"
    echo "Test: curl http://localhost/api/portfolio/projects"
    
elif [ "$choice" = "2" ]; then
    echo ""
    echo "ℹ️  Keeping nginx on port 8080"
    echo "Access your API at: http://localhost:8080/api/portfolio/projects"
else
    echo "❌ Invalid choice"
    exit 1
fi
