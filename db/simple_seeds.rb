puts "Running simple seeds with image filenames..."

# Create categories
cat1 = Category.find_or_create_by!(name: 'Apparel')
cat2 = Category.find_or_create_by!(name: 'Electronics') 
cat3 = Category.find_or_create_by!(name: 'Furniture')

# Clear existing products
Product.destroy_all

# Create products with image filenames
cat1.products.create!({
  name: 'Men\'s Classy Shirt',
  description: 'A sophisticated and stylish shirt perfect for any occasion. Made with high-quality materials for comfort and durability.',
  quantity: 10,
  price: 64.99,
  image_filename: 'apparel1.jpg'
})

cat1.products.create!({
  name: 'Women\'s Zebra Pants',
  description: 'Bold and fashionable zebra print pants that make a statement. Comfortable fit with modern styling.',
  quantity: 18,
  price: 124.99,
  image_filename: 'apparel2.jpg'
})

cat1.products.create!({
  name: 'Hipster Hat',
  description: 'Trendy hat perfect for the fashion-forward individual. Adds the perfect finishing touch to any outfit.',
  quantity: 4,
  price: 34.49,
  image_filename: 'apparel3.jpg'
})

cat1.products.create!({
  name: 'Hipster Socks',
  description: 'Comfortable and stylish socks with unique patterns. Made from premium materials for all-day comfort.',
  quantity: 8,
  price: 25.00,
  image_filename: 'apparel4.jpg'
})

cat1.products.create!({
  name: 'Russian Spy Shoes',
  description: 'Mysterious and elegant footwear with a hint of espionage sophistication. Crafted with attention to detail.',
  quantity: 8,
  price: 1225.00,
  image_filename: 'apparel5.jpg'
})

cat1.products.create!({
  name: 'Human Feet Shoes',
  description: 'Uniquely designed shoes that blur the line between fashion and art. A conversation starter.',
  quantity: 82,
  price: 224.50,
  image_filename: 'apparel6.jpg'
})

cat2.products.create!({
  name: 'Modern Skateboards',
  description: 'High-quality skateboard perfect for beginners and pros alike. Durable construction with smooth riding experience.',
  quantity: 40,
  price: 164.49,
  image_filename: 'electronics1.jpg'
})

cat2.products.create!({
  name: 'Hotdog Slicer',
  description: 'Innovative kitchen gadget that makes perfect hotdog slices every time. Easy to use and clean.',
  quantity: 3,
  price: 26.00,
  image_filename: 'electronics2.jpg'
})

cat2.products.create!({
  name: 'World\'s Largest Smartwatch',
  description: 'Revolutionary smartwatch with massive display and incredible features. The future of wearable technology.',
  quantity: 32,
  price: 2026.29,
  image_filename: 'electronics3.jpg'
})

cat3.products.create!({
  name: 'Optimal Sleeping Bed',
  description: 'Premium mattress designed for the perfect night\'s sleep. Ergonomic design with superior comfort.',
  quantity: 320,
  price: 3052.00,
  image_filename: 'furniture1.jpg'
})

cat3.products.create!({
  name: 'Electric Chair',
  description: 'Modern electric recliner with multiple positions and massage features. Ultimate relaxation furniture.',
  quantity: 2,
  price: 987.65,
  image_filename: 'furniture2.jpg'
})

cat3.products.create!({
  name: 'Red Bookshelf',
  description: 'Beautiful red bookshelf that adds color and storage to any room. Sturdy construction with ample space.',
  quantity: 0,
  price: 2483.75,
  image_filename: 'furniture3.jpg'
})

puts "Simple seeding completed!"
puts "Created #{Category.count} categories and #{Product.count} products with images"