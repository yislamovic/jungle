#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Set dummy DATABASE_URL for asset precompilation only
export DATABASE_URL="postgresql://user:pass@127.0.0.1/dummy"
RAILS_ENV=production bundle exec rails assets:precompile
bundle exec rails assets:clean

# Reset DATABASE_URL to empty so Render can set the real one
unset DATABASE_URL

# Database operations will run when the service starts
bundle exec rails db:migrate
bundle exec rails db:seed