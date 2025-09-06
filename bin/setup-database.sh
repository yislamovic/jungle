#!/usr/bin/env bash
# Database setup script for Render
set -o errexit

echo "Running database migrations..."
bundle exec rails db:migrate

echo "Seeding database..."
bundle exec rails db:seed

echo "Database setup complete!"