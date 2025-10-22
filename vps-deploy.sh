#!/bin/bash
set -e

echo "🚀 Jungle VPS Deployment Script"
echo "================================"

# Navigate to project
cd /var/www/projects/jungle

# Create .env if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file..."
    cat > .env << 'EOF'
SECRET_KEY_BASE=f03d716cb26cb1de3b8c9c8e0c69b1deb8373a2793a94dda709bf94adcd2422215bc8570aafefabaec370125c375a168af97d48a28fd749b50927ecae1626058
STRIPE_PUBLISHABLE_KEY=pk_test_51Ja4bIF7K9QmHphkHyQ5FH3RzHC6aaY6a0VnLY6VdTQlclboVWur4lof1ZBbOj8hDWs3Y6UgRTcQvXJ8aWbCbc5J00ub1j1173
STRIPE_SECRET_KEY=sk_test_51Ja4bIF7K9QmHphkmk8boKKgMMq73y8476ABDrB9xg3hF5rxgyFTWjRhVmQYdDyVAitguYP94S3KM73GqeUnKLYL00yNLnL7nO
HTTP_BASIC_USER=admin
HTTP_BASIC_PASSWORD=junglebook
EOF
    echo "✅ .env created"
else
    echo "✅ .env already exists"
fi

# Pull latest code
echo "📥 Pulling latest code..."
git pull

# Stop old containers
echo "🛑 Stopping old containers..."
docker compose down 2>/dev/null || true
docker compose -f docker-compose.production.yml down 2>/dev/null || true

# Build and start
echo "🏗️  Building production container..."
docker compose -f docker-compose.production.yml build --no-cache

echo "▶️  Starting container..."
docker compose -f docker-compose.production.yml up -d

# Wait for container to be healthy
echo "⏳ Waiting for container to be healthy..."
sleep 10

# Check status
echo ""
echo "📊 Container Status:"
docker compose -f docker-compose.production.yml ps

echo ""
echo "📝 Recent logs:"
docker compose -f docker-compose.production.yml logs --tail=20 web

echo ""
echo "✅ Deployment complete!"
echo "🌐 Access your site at: http://jungle.yahyaislamovic.dev"
echo "🔧 Admin panel: http://jungle.yahyaislamovic.dev/admin"
echo ""
echo "To view live logs: docker compose -f docker-compose.production.yml logs -f web"
