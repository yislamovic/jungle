-- Enable plpgsql extension
CREATE EXTENSION IF NOT EXISTS plpgsql;

-- Create schema_migrations table for Rails
CREATE TABLE IF NOT EXISTS schema_migrations (
  version varchar NOT NULL PRIMARY KEY
);

-- Insert schema version
INSERT INTO schema_migrations (version) VALUES ('20210917233900') ON CONFLICT DO NOTHING;

-- Create ar_internal_metadata table for Rails
CREATE TABLE IF NOT EXISTS ar_internal_metadata (
  key varchar PRIMARY KEY,
  value varchar,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
  id serial PRIMARY KEY,
  name varchar,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
  id serial PRIMARY KEY,
  total_cents integer,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  stripe_charge_id varchar,
  email varchar
);

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id serial PRIMARY KEY,
  name varchar,
  description text,
  image varchar,
  price_cents integer,
  quantity integer,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL,
  category_id integer
);

-- Create line_items table
CREATE TABLE IF NOT EXISTS line_items (
  id serial PRIMARY KEY,
  order_id integer,
  product_id integer,
  quantity integer,
  item_price_cents integer,
  total_price_cents integer,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

-- Create users table
CREATE TABLE IF NOT EXISTS users (
  id serial PRIMARY KEY,
  email varchar,
  password_digest varchar,
  first_name varchar,
  last_name varchar,
  created_at timestamp NOT NULL,
  updated_at timestamp NOT NULL
);

-- Add indexes
CREATE INDEX IF NOT EXISTS index_line_items_on_order_id ON line_items (order_id);
CREATE INDEX IF NOT EXISTS index_line_items_on_product_id ON line_items (product_id);
CREATE INDEX IF NOT EXISTS index_products_on_category_id ON products (category_id);

-- Add foreign keys
ALTER TABLE line_items ADD CONSTRAINT fk_rails_order_id 
  FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE;
  
ALTER TABLE line_items ADD CONSTRAINT fk_rails_product_id
  FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE;
  
ALTER TABLE products ADD CONSTRAINT fk_rails_category_id
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE;