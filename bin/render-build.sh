#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install

# Precompile assets without database connection
RAILS_ENV=production bundle exec rails assets:precompile
bundle exec rails assets:clean

# Database operations (these run after the web service starts)
bundle exec rails db:migrate
bundle exec rails db:seed