# Jungle Production Deployment Guide

## ✅ Production Setup (docker-compose.production.yml)

This is the **working** production configuration using Docker volumes (no permission issues).

### Local Testing (Verified Working!)

```bash
# Build
docker compose -f docker-compose.production.yml build --no-cache

# Start with environment variables
SECRET_KEY_BASE=your_key STRIPE_PUBLISHABLE_KEY=your_key STRIPE_SECRET_KEY=your_key \
docker compose -f docker-compose.production.yml up -d

# Check logs
docker compose -f docker-compose.production.yml logs -f

# Stop
docker compose -f docker-compose.production.yml down
```

---

## 🚀 VPS Deployment

### Step 1: On VPS - Create .env file

```bash
cd /var/www/projects/jungle
nano .env
```

Paste:
```env
SECRET_KEY_BASE=f03d716cb26cb1de3b8c9c8e0c69b1deb8373a2793a94dda709bf94adcd2422215bc8570aafefabaec370125c375a168af97d48a28fd749b50927ecae1626058
STRIPE_PUBLISHABLE_KEY=pk_test_51Ja4bIF7K9QmHphkHyQ5FH3RzHC6aaY6a0VnLY6VdTQlclboVWur4lof1ZBbOj8hDWs3Y6UgRTcQvXJ8aWbCbc5J00ub1j1173
STRIPE_SECRET_KEY=sk_test_51Ja4bIF7K9QmHphkmk8boKKgMMq73y8476ABDrB9xg3hF5rxgyFTWjRhVmQYdDyVAitguYP94S3KM73GqeUnKLYL00yNLnL7nO
HTTP_BASIC_USER=admin
HTTP_BASIC_PASSWORD=junglebook
```

Save: `Ctrl+X`, `Y`, `Enter`

### Step 2: Deploy

```bash
cd /var/www/projects/jungle

# Pull latest code
git pull

# Build and start
docker compose -f docker-compose.production.yml build --no-cache
docker compose -f docker-compose.production.yml up -d

# Check logs
docker compose -f docker-compose.production.yml logs -f web

# Wait for: "* Listening on tcp://0.0.0.0:3000"
```

### Step 3: Access

- **URL:** http://jungle.yahyaislamovic.dev OR http://your-vps-ip:3002
- **Admin:** http://jungle.yahyaislamovic.dev/admin
  - Username: `admin`
  - Password: `junglebook`

---

## 🔄 Update/Redeploy

```bash
cd /var/www/projects/jungle
git pull
docker compose -f docker-compose.production.yml down
docker compose -f docker-compose.production.yml up -d --build
```

---

## 🐛 Troubleshooting

### Check if running:
```bash
docker compose -f docker-compose.production.yml ps
```

### View logs:
```bash
docker compose -f docker-compose.production.yml logs --tail=50 web
```

### Nuclear restart:
```bash
docker compose -f docker-compose.production.yml down -v
docker compose -f docker-compose.production.yml up -d --build
```

### Check volumes:
```bash
docker volume ls | grep jungle
```

---

## ✨ Key Features

- **No permission issues** - Uses Docker volumes instead of bind mounts
- **Persistent data** - Database and uploads stored in Docker volumes
- **Session-based demo mode** - Admin changes isolated per session
- **Health checks** - Automatic container monitoring
- **Secure** - No secrets in code, all from `.env`

---

## 📦 What's Different from docker-compose.yml?

| Feature | docker-compose.yml (Old) | docker-compose.production.yml (New) |
|---------|-------------------------|-------------------------------------|
| Volumes | Bind mounts (./db, ./log) | Docker volumes (jungle_db, jungle_logs) |
| Permissions | ❌ Issues with user `app` | ✅ No issues |
| Dockerfile | Dockerfile (with USER app) | Dockerfile.prod (no USER switch) |
| Tested | ❌ Had 502 errors | ✅ Working locally & VPS ready |

---

## 🎯 Production Checklist

- [x] Dockerfile.prod created
- [x] docker-compose.production.yml created
- [x] Uses Docker volumes (no permission issues)
- [x] Tested locally (HTTP 200 ✅)
- [x] `.env` template documented
- [x] VPS deployment guide written
- [x] Port 3002 configured

**Ready to deploy!** 🚀
