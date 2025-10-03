# VPS Deployment Guide for Jungle E-Commerce App

This guide will help you deploy the Jungle Rails application on any VPS (DigitalOcean, Linode, AWS EC2, etc.) using Docker.

## Prerequisites

- A VPS with at least 2GB RAM (recommended)
- Ubuntu 20.04 or 22.04 LTS
- Root or sudo access
- A domain name (optional but recommended)

## Step 1: Server Setup

### 1.1 Connect to Your VPS

```bash
ssh root@your_server_ip
```

### 1.2 Update System Packages

```bash
apt update && apt upgrade -y
```

### 1.3 Install Docker

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install docker-compose -y

# Verify installation
docker --version
docker-compose --version
```

### 1.4 Create a Non-Root User (Recommended)

```bash
adduser jungle
usermod -aG sudo jungle
usermod -aG docker jungle

# Switch to the new user
su - jungle
```

## Step 2: Deploy the Application

### 2.1 Clone the Repository

```bash
cd ~
git clone <your-repository-url> jungle
cd jungle
```

### 2.2 Configure Environment Variables

```bash
# Copy the example environment file
cp .env.production.example .env.production

# Generate a secure SECRET_KEY_BASE
docker run --rm ruby:3.1-slim bundle exec rails secret

# Edit the environment file
nano .env.production
```

Fill in these required values:
```env
SECRET_KEY_BASE=<paste the generated secret from above>
DATABASE_PASSWORD=<create a strong password>
STRIPE_PUBLISHABLE_KEY=<your Stripe publishable key>
STRIPE_SECRET_KEY=<your Stripe secret key>
HTTP_BASIC_USER=admin
HTTP_BASIC_PASSWORD=<create a strong admin password>
PORT=3000
```

Save and exit (Ctrl+X, then Y, then Enter).

### 2.3 Build and Start the Application

```bash
# Build the Docker images
docker-compose -f docker-compose.prod.yml build

# Start the application
docker-compose -f docker-compose.prod.yml up -d

# Check the logs
docker-compose -f docker-compose.prod.yml logs -f
```

The application should now be running on port 3000.

### 2.4 Verify Deployment

```bash
# Check container status
docker-compose -f docker-compose.prod.yml ps

# Test the application
curl http://localhost:3000
```

## Step 3: Configure Nginx (Reverse Proxy)

### 3.1 Install Nginx

```bash
sudo apt install nginx -y
```

### 3.2 Create Nginx Configuration

```bash
sudo nano /etc/nginx/sites-available/jungle
```

Add this configuration (replace `your_domain.com` with your actual domain or server IP):

```nginx
upstream jungle_app {
    server localhost:3000;
}

server {
    listen 80;
    server_name your_domain.com;  # Replace with your domain or server IP

    # Increase upload size limit
    client_max_body_size 10M;

    location / {
        proxy_pass http://jungle_app;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
    }

    # Serve static files directly
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|svg|woff|woff2|ttf|eot)$ {
        proxy_pass http://jungle_app;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

### 3.3 Enable the Site

```bash
# Create symbolic link
sudo ln -s /etc/nginx/sites-available/jungle /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

## Step 4: Configure SSL with Let's Encrypt (Optional but Recommended)

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Obtain SSL certificate
sudo certbot --nginx -d your_domain.com

# Auto-renewal is set up automatically
sudo certbot renew --dry-run
```

## Step 5: Configure Firewall

```bash
# Allow SSH, HTTP, and HTTPS
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
```

## Management Commands

### Start the Application
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml up -d
```

### Stop the Application
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml down
```

### View Logs
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml logs -f
```

### Restart the Application
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml restart
```

### Update the Application
```bash
cd ~/jungle
git pull origin master
docker-compose -f docker-compose.prod.yml build
docker-compose -f docker-compose.prod.yml up -d
```

### Database Backup
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml exec db pg_dump -U jungle jungle_production > backup_$(date +%Y%m%d_%H%M%S).sql
```

### Database Restore
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml exec -T db psql -U jungle jungle_production < backup_file.sql
```

### Access Rails Console
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml exec web bundle exec rails console
```

### Run Database Migrations
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml exec web bundle exec rails db:migrate
```

## Monitoring and Maintenance

### Check Disk Space
```bash
df -h
docker system df
```

### Clean Up Old Docker Images
```bash
docker system prune -a --volumes
```

### Monitor Container Resources
```bash
docker stats
```

## Troubleshooting

### Application Won't Start
```bash
# Check logs
docker-compose -f docker-compose.prod.yml logs web

# Check database logs
docker-compose -f docker-compose.prod.yml logs db

# Verify environment variables
docker-compose -f docker-compose.prod.yml config
```

### Database Connection Issues
```bash
# Check if database is healthy
docker-compose -f docker-compose.prod.yml ps

# Restart database
docker-compose -f docker-compose.prod.yml restart db
```

### Permission Issues
```bash
# Fix file permissions
sudo chown -R $(whoami):$(whoami) ~/jungle
```

### Reset Everything (Nuclear Option)
```bash
cd ~/jungle
docker-compose -f docker-compose.prod.yml down -v
docker-compose -f docker-compose.prod.yml up -d
```

## Performance Optimization

### Enable Docker Logging Limits
Add to `docker-compose.prod.yml` under each service:
```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

### Configure Swap (for servers with limited RAM)
```bash
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

## Security Best Practices

1. ✅ Change all default passwords
2. ✅ Use SSL/TLS certificates
3. ✅ Keep system packages updated: `sudo apt update && sudo apt upgrade`
4. ✅ Enable firewall (ufw)
5. ✅ Use strong database passwords
6. ✅ Regularly backup your database
7. ✅ Monitor application logs
8. ✅ Use environment variables for secrets (never commit them)

## Testing Your Deployment

1. **Homepage**: Visit `http://your_domain.com` or `http://your_server_ip`
2. **Admin Panel**: Visit `http://your_domain.com/admin/products`
   - Username: Value from `HTTP_BASIC_USER`
   - Password: Value from `HTTP_BASIC_PASSWORD`
3. **Stripe Checkout**: Use test card `4111 1111 1111 1111`

## Support

For issues specific to:
- **Docker**: Check Docker logs and container status
- **Nginx**: Check `/var/log/nginx/error.log`
- **Rails**: Check application logs in `~/jungle/log/production.log`
- **Database**: Check database logs and connection settings

## Estimated Costs

- **VPS (DigitalOcean/Linode)**: $6-12/month (2GB RAM)
- **Domain Name**: $10-15/year (optional)
- **SSL Certificate**: Free (Let's Encrypt)
- **Total**: ~$6-12/month

---

**Congratulations!** Your Jungle e-commerce application is now deployed on a VPS! 🚀
