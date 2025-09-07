#!/bin/bash
set -e

echo "🧪 Testing Production Environment Locally"
echo "=========================================="

# Setup environment
export RAILS_ENV=production
export SECRET_KEY_BASE=test_secret_key_for_local_testing_only
export DATABASE_URL=sqlite3:db/production.sqlite3
export RAILS_SERVE_STATIC_FILES=true
export RAILS_LOG_TO_STDOUT=true
export PATH="/opt/homebrew/opt/ruby@3.1/bin:$PATH"

echo "📊 Setting up production database..."
bundle exec rails db:create db:migrate

echo "🌱 Running simple database seeds..."  
if [ -f "db/simple_seeds.rb" ]; then
  bundle exec rails runner "load 'db/simple_seeds.rb'"
else
  bundle exec rails db:seed
fi

echo "🖼️  Setting up product images..."
bundle exec rails production:setup_images

echo "🏥 Running health check..."
bundle exec rails production:health_check

echo ""
echo "✅ Production environment setup complete!"
echo "🚀 Starting production server on http://localhost:3000"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Start the production server
bundle exec rails server -b 0.0.0.0 -p 3000