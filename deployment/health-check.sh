#!/bin/bash

# Health Check Script for Chat-IoC Application
# Usage: ./health-check.sh [service]

set -e

FRONTEND_URL=${FRONTEND_URL:-"http://localhost"}
BACKEND_URL=${BACKEND_URL:-"http://localhost:8080"}

case "$1" in
  "frontend")
    echo "Checking frontend health..."
    if curl -f -s "$FRONTEND_URL" > /dev/null; then
      echo "✓ Frontend is healthy"
      exit 0
    else
      echo "✗ Frontend is unhealthy"
      exit 1
    fi
    ;;
  "backend")
    echo "Checking backend health..."
    if curl -f -s "$BACKEND_URL/api/health" > /dev/null; then
      echo "✓ Backend is healthy"
      exit 0
    else
      echo "✗ Backend is unhealthy"
      exit 1
    fi
    ;;
  "all"|"")
    echo "Checking overall application health..."
    
    # Check backend first
    if ! curl -f -s "$BACKEND_URL/api/health" > /dev/null; then
      echo "✗ Backend is unhealthy"
      exit 1
    fi
    
    echo "✓ Backend is healthy"
    
    # Then check frontend
    if ! curl -f -s "$FRONTEND_URL" > /dev/null; then
      echo "✗ Frontend is unhealthy"
      exit 1
    fi
    
    echo "✓ Frontend is healthy"
    echo "✓ Overall application is healthy"
    ;;
  *)
    echo "Usage: $0 [frontend|backend|all]"
    exit 1
    ;;
esac