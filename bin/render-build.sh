#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Only precompile assets - no database operations during build
RAILS_ENV=production DATABASE_URL=postgresql://user:pass@localhost/myapp_production bundle exec rails assets:precompile
bundle exec rails assets:clean