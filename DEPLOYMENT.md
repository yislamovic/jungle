# Deploying Jungle to Render

This guide will help you deploy the Jungle e-commerce application to Render.

## Prerequisites

1. Your code should be pushed to a GitHub repository
2. A Render account (sign up at render.com)

## Deployment Steps

### 1. Create PostgreSQL Database

1. In your Render dashboard, click "New" → "PostgreSQL"
2. Configure:
   - **Name**: `jungle-db`
   - **Database**: `jungle_production`  
   - **User**: `jungle`
   - **Region**: Choose closest to your users
   - **Plan**: Free (or higher as needed)
3. Click "Create Database"
4. Wait for the database to be ready

### 2. Deploy the Web Service

1. In Render dashboard, click "New" → "Web Service"
2. Connect your GitHub repository containing this code
3. Configure:
   - **Name**: `jungle-rails-app`
   - **Environment**: `Ruby`
   - **Branch**: `master` (or `main`)
   - **Root Directory**: Leave blank
   - **Build Command**: `./bin/render-build.sh`
   - **Start Command**: `bundle exec rails server -b 0.0.0.0 -p $PORT -e production`
   - **Plan**: Free (or higher as needed)

### 3. Set Environment Variables

In your web service settings, go to "Environment" and add these variables:

**Required Variables:**
- `RAILS_MASTER_KEY` - Copy from your local `config/master.key` file
- `DATABASE_URL` - Auto-populated from the database connection
- `RAILS_ENV` - Set to `production`
- `NODE_ENV` - Set to `production`
- `BUNDLE_WITHOUT` - Set to `development:test`

**Stripe Configuration (for payments):**
- `STRIPE_PUBLISHABLE_KEY` - Your Stripe publishable test key
- `STRIPE_SECRET_KEY` - Your Stripe secret test key

**Admin Access:**
- `HTTP_BASIC_USER` - Set to `admin`
- `HTTP_BASIC_PASSWORD` - Set a secure password for admin access

### 4. Deploy

1. Click "Create Web Service"
2. Render will automatically:
   - Build your application using the build script
   - Run database migrations
   - Seed the database with initial data
   - Start your Rails application

### 5. Verify Deployment

Once deployed, visit your app URL and verify:
- ✅ Home page loads with products
- ✅ Product categories work
- ✅ Shopping cart functionality
- ✅ Admin panel at `/admin/products` (use your admin credentials)
- ✅ Stripe checkout (use test card: `4111 1111 1111 1111`)

## Configuration Files

The following files have been configured for Render deployment:

- `render.yaml` - Render service configuration
- `bin/render-build.sh` - Build script for deployment
- `config/database.yml` - Updated for production DATABASE_URL
- `config/environments/production.rb` - Configured for Render static files

## Troubleshooting

### Build Fails
- Check the build logs in Render dashboard
- Ensure all environment variables are set correctly
- Verify `bin/render-build.sh` is executable

### Database Connection Issues
- Verify DATABASE_URL is correctly linked from the database service
- Check database service is running and accessible

### Static Assets Not Loading
- Ensure `RAILS_SERVE_STATIC_FILES` or `RENDER` environment variable is present
- Check that assets were precompiled during build

### Admin Panel Access Issues
- Verify `HTTP_BASIC_USER` and `HTTP_BASIC_PASSWORD` are set
- Ensure the values match what you use for login

## Test Data

The application comes with pre-seeded data:
- 3 product categories
- 12 sample products with images
- Test user account

## Stripe Testing

Use these test credit card numbers:
- **Success**: `4111 1111 1111 1111`
- **Declined**: `4000 0000 0000 0002`

Any future expiry date and any 3-digit CVC will work.

## Support

For deployment issues, check:
1. Render build and runtime logs
2. Environment variable configuration
3. Database connectivity
4. Static file serving configuration