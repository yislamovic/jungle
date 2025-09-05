# Jungle

A mini e-commerce application built with Rails 6.1 (upgraded from Rails 4.2). This project demonstrates a fully functional online store with product listings, shopping cart, secure checkout, and admin management capabilities.

## ⚡ Recent Updates (2025)

**Major Rails Upgrade Completed:**
- ✅ Upgraded from Rails 4.2.11 to Rails 6.1.7.10
- ✅ Upgraded from Ruby 2.6.10 to Ruby 3.1.7
- ✅ Fixed Apple Silicon (ARM64) compatibility issues
- ✅ Updated all dependencies for modern compatibility
- ✅ Fixed CarrierWave image handling for Rails 6.1
- ✅ Implemented robust error handling and user creation
- ✅ Added admin authentication system

## 🌟 Features

- **Product Management**: Browse products by category with detailed descriptions and images
- **Shopping Cart**: Add/remove items with real-time quantity updates
- **Secure Checkout**: Stripe payment integration with automatic user creation
- **Admin Panel**: Product management with HTTP Basic authentication
- **Responsive Design**: Bootstrap-based UI that works on all devices
- **Image Gallery**: CarrierWave integration with multiple image sizes (thumbnail, tiny, full)

## 📸 Screenshots
!["Shows item checkout."](https://github.com/yislamovic/jungle/blob/master/docs/checkout.png?raw=true)
!["Shows all the products."](https://github.com/yislamovic/jungle/raw/master/docs/products.png)
!["Shows the signup process."](https://github.com/yislamovic/jungle/raw/master/docs/signup.png)
!["Shows the admin page; add a product!"](https://github.com/yislamovic/jungle/raw/master/docs/admin-products.png)

## 🚀 Quick Start

### Prerequisites
- Ruby 3.1.7
- PostgreSQL
- ImageMagick (for image processing)

### Installation

1. **Clone and install dependencies:**
   ```bash
   git clone <your-repo-url>
   cd jungle
   bundle install
   ```

2. **Database setup:**
   ```bash
   # The database is pre-configured with setup and seed files
   psql -c "CREATE USER jungle WITH CREATEDB PASSWORD 'password';"
   psql -U jungle -d postgres -f setup_db.sql
   psql -U jungle -d jungle_development -f seed_data.sql
   ```

3. **Environment configuration:**
   ```bash
   # Copy the .env file (already configured with test credentials)
   # Update Stripe keys if needed
   ```

4. **Start the server:**
   ```bash
   bin/rails server
   ```

5. **Access the application:**
   - **Main site**: http://localhost:3000
   - **Admin panel**: http://localhost:3000/admin/products
     - Username: `admin`
     - Password: `junglebook`

## 💳 Stripe Testing

Use these test credit card numbers:
- **Success**: `4111 1111 1111 1111`
- **Declined**: `4000 0000 0000 0002`

Any future expiry date and any 3-digit CVC will work with test cards.

More information: [Stripe Testing Documentation](https://stripe.com/docs/testing#cards)

## 🛠️ Technical Details

### Current Technology Stack
- **Backend**: Rails 6.1.7.10
- **Ruby**: 3.1.7
- **Database**: PostgreSQL
- **Payment Processing**: Stripe API
- **Image Processing**: CarrierWave + MiniMagick
- **Authentication**: HTTP Basic Auth (admin), bcrypt (user accounts)
- **Frontend**: Bootstrap, SCSS, ERB templates

### Database Schema
- **Products**: Name, description, price, quantity, category association, image upload
- **Categories**: Organized product groupings
- **Users**: Email-based accounts with secure password storage
- **Orders**: Complete order tracking with line items and Stripe integration
- **Line Items**: Individual product entries within orders

### Key Features Implemented
- ✅ Product catalog with categorization
- ✅ Shopping cart with session persistence
- ✅ User registration and authentication
- ✅ Stripe payment integration
- ✅ Admin product management
- ✅ Responsive image handling
- ✅ Order management system
- ✅ Robust error handling

## 🔧 Development Notes

### Image Management
Images are processed through CarrierWave with three sizes:
- **Full size**: Original uploaded image
- **Thumb**: 300x300px for product listings
- **Tiny**: 100x100px for cart/admin views

### Admin Access
Admin functionality is protected by HTTP Basic Authentication. Use the credentials provided above to access product management features.

### Error Handling
The application includes comprehensive error handling for:
- Missing product images
- Failed payment processing
- User creation during checkout
- Invalid form submissions

## 📦 Dependencies

- **Rails**: 6.1.7.10
- **Ruby**: 3.1.7
- **PostgreSQL**: 9.x+
- **Stripe**: Payment processing
- **CarrierWave**: File uploads
- **MiniMagick**: Image processing
- **Bootstrap**: UI framework
- **bcrypt**: Password encryption
