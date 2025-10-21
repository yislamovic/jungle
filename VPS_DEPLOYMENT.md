# VPS Deployment Guide for Jungle E-Commerce

## Pre-Deployment Checklist

### ✅ Security
- [x] No hardcoded secrets in code
- [x] `.env` is in `.gitignore`
- [x] Stripe keys use environment variables
- [x] `SECRET_KEY_BASE` uses environment variable

### ⚠️ REQUIRED: Set up environment variables on VPS

## Steps to Deploy on VPS

### 1. SSH into your VPS
```bash
ssh your-user@your-vps-ip
```

### 2. Clone the repository
```bash
git clone <your-repo-url>
cd jungle
```

### 3. Create `.env` file (CRITICAL!)
```bash
nano .env
```

### 4. Build and start the application
```bash
docker compose up -d --build
```

### 5. Check logs
```bash
docker compose logs -f web
```

### 6. Access the site
- Public site: `http://your-vps-ip:3000`
- Admin panel: `http://your-vps-ip:3000/admin`
  - Username: `admin`
  - Password: `junglebook`

## Port Configuration

If you want to use port 80 (default HTTP), edit `docker-compose.yml`:
```yaml
ports:
  - "80:3000"  # Changed from "3000:3000"
```

## Troubleshooting

### Issue: Stripe checkout shows "missing key parameter"
**Solution:** Make sure `.env` file exists on VPS with correct Stripe keys

### Issue: Rails shows "Invalid secret key"
**Solution:** Generate a new `SECRET_KEY_BASE` and add to `.env`

### Issue: Can't access admin panel
**Solution:** Check `HTTP_BASIC_USER` and `HTTP_BASIC_PASSWORD` in `.env`

## Production Checklist

For actual production deployment (not demo):

1. ✅ Use a real database (PostgreSQL recommended, not SQLite)
2. ✅ Set up SSL/HTTPS with Let's Encrypt
3. ✅ Use strong passwords for admin
4. ✅ Generate a unique `SECRET_KEY_BASE`
5. ✅ Use production Stripe keys (not test keys)
6. ✅ Set up regular backups
7. ✅ Configure firewall (ufw)
8. ✅ Set up monitoring

## Demo Mode Features

This app has session-based demo mode:
- Admin can add/delete products
- Changes are per-browser-session only
- No database modifications
- Data resets when browser closes
- Each visitor gets isolated workspace
