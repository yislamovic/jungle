#!/bin/bash
set -e

# Remove stale PID file if it exists
if [ -f tmp/pids/server.pid ]; then
  echo "Removing stale PID file..."
  rm -f tmp/pids/server.pid
fi

# Setup database if needed
echo "Setting up production database..."
bundle exec rails db:prepare

# Run seeds
echo "Running seeds..."
bundle exec rails db:seed

# Start the server
echo "Starting server..."
exec "$@"
