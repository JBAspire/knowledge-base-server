#!/bin/bash
set -e

echo "=== Deploying Knowledge Base Server ==="
echo "Started at $(date)"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

COMPOSE="docker compose -f docker-compose.yml -f docker-compose.prod.yml"

# Pull latest code
echo "Pulling latest code..."
git pull origin master

# Rebuild and restart
echo "Rebuilding container..."
$COMPOSE up -d --build

echo ""
echo "=== Deployment complete at $(date) ==="