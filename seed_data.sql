-- Insert categories
INSERT INTO categories (name, created_at, updated_at) VALUES 
('Apparel', NOW(), NOW()),
('Electronics', NOW(), NOW()),
('Furniture', NOW(), NOW());

-- Get category IDs
-- Assuming category IDs are 1, 2, 3 in order

-- Insert products
INSERT INTO products (name, description, image, price_cents, quantity, created_at, updated_at, category_id) VALUES
('Men''s Classy shirt', 'Classic comfort and style combined. This classy men''s shirt features quality fabric and timeless design that works for both casual and business settings. Perfect fit guaranteed to make you look sharp.', 'apparel1.jpg', 6499, 10, NOW(), NOW(), 1),
('Women''s Zebra pants', 'Stand out with these stunning zebra-patterned pants. High-quality fabric ensures comfort while the unique pattern makes a bold fashion statement. Perfect for those who dare to be different.', 'apparel2.jpg', 12499, 18, NOW(), NOW(), 1),
('Hipster Hat', 'Complete your look with this trendy hipster hat. Made from sustainable materials, this hat combines eco-consciousness with urban style. One size fits most.', 'apparel3.jpg', 3499, 4, NOW(), NOW(), 1),
('Hipster Socks', 'Express yourself from head to toe with these colorful hipster socks. Made from organic cotton blend for maximum comfort. Comes in unique patterns that add personality to any outfit.', 'apparel4.jpg', 2500, 8, NOW(), NOW(), 1),
('Russian Spy Shoes', 'Mysterious and sophisticated footwear inspired by classic espionage tales. These shoes feature hidden compartments and exceptional comfort for long days of adventure.', 'apparel5.jpg', 125000, 8, NOW(), NOW(), 1),
('Human Feet Shoes', 'Revolutionary barefoot-style shoes that mimic the natural shape and movement of human feet. Perfect for those seeking a more natural walking experience.', 'apparel6.jpg', 22499, 82, NOW(), NOW(), 1),
('Modern Skateboards', 'High-performance skateboard with modern design and durable construction. Features premium wheels and bearings for smooth rides and epic tricks.', 'electronics1.jpg', 16499, 40, NOW(), NOW(), 2),
('Hotdog Slicer', 'The ultimate kitchen gadget for hotdog enthusiasts. This precision slicer creates perfect spiral cuts for gourmet hotdog presentations.', 'electronics2.jpg', 2699, 3, NOW(), NOW(), 2),
('World''s Largest Smartwatch', 'Make a statement with this oversized smartwatch. Features all standard smartwatch capabilities in an attention-grabbing size. Battery life may vary.', 'electronics3.jpg', 200099, 32, NOW(), NOW(), 2),
('Optimal Sleeping Bed', 'Experience the best sleep of your life with this scientifically designed bed. Features advanced support technology and premium materials for optimal rest.', 'furniture1.jpg', 308699, 24, NOW(), NOW(), 3),
('Electric Chair', 'A conversation starter for any room. This replica electric chair has been converted into a comfortable recliner with built-in massage features.', 'furniture2.jpg', 98799, 2, NOW(), NOW(), 3),
('Red Bookshelf', 'Bold and beautiful red bookshelf that adds a pop of color to any room. Multiple shelves provide ample storage for books, decorations, and more.', 'furniture3.jpg', 234599, 23, NOW(), NOW(), 3);

-- Insert a sample user (password is 'password123' hashed with bcrypt)
INSERT INTO users (email, password_digest, first_name, last_name, created_at, updated_at) VALUES
('demo@jungle.com', '$2a$12$YQV6PlNLP3YaHxp1IaWET.L2Rt4xvLGc9FZmJKMOE.V3u0cMxvlDa', 'Demo', 'User', NOW(), NOW());