#!/usr/bin/env ruby
# Fix images by mapping existing directories to current products

puts "🔧 Fixing image connections by mapping existing files to current products..."

# Current products from simple seeds (IDs 29-38) and their expected original images
current_products = Product.all.order(:id)

# Mapping based on product names to their original seed asset files  
name_to_image = {
  "Men's Classy Shirt" => 'apparel1.jpg',
  "Women's Zebra Pants" => 'apparel2.jpg', 
  "Hipster Hat" => 'apparel3.jpg',
  "Hipster Socks" => 'apparel4.jpg',
  "Modern Skateboards" => 'electronics1.jpg',
  "Hotdog Slicer" => 'electronics2.jpg', 
  "World's Largest Smartwatch" => 'electronics3.jpg',
  "Optimal Sleeping Bed" => 'furniture1.jpg',
  "Electric Chair" => 'furniture2.jpg',
  "Red Bookshelf" => 'furniture3.jpg'
}

# Find which old image directories contain each image file
image_to_directory = {}
Dir.glob(Rails.root.join('public', 'uploads', 'product', 'image', '*')).each do |dir|
  next unless File.directory?(dir)
  
  dir_id = File.basename(dir)
  next unless dir_id.match?(/^\d+$/)
  
  # Check what image files are in this directory
  image_files = Dir.glob(File.join(dir, '**', '*.jpg')).map { |f| File.basename(f) }
  
  name_to_image.each do |product_name, filename|
    if image_files.include?(filename)
      image_to_directory[filename] = dir_id
      break
    end
  end
end

puts "📂 Found image directories:"
image_to_directory.each do |filename, dir_id|
  puts "   #{filename} -> directory #{dir_id}"
end

fixed_count = 0

current_products.each do |product|
  expected_image = name_to_image[product.name]
  
  if expected_image && image_to_directory[expected_image]
    old_dir = image_to_directory[expected_image]
    new_dir = product.id.to_s
    
    puts "\n🔄 Fixing #{product.name}:"
    puts "   Expected image: #{expected_image}"
    puts "   Found in old directory: #{old_dir}"
    puts "   Current product ID: #{product.id}"
    
    # Copy the image directory to the new product ID location
    old_path = Rails.root.join('public', 'uploads', 'product', 'image', old_dir)
    new_path = Rails.root.join('public', 'uploads', 'product', 'image', new_dir)
    
    if Dir.exist?(old_path) && !Dir.exist?(new_path)
      FileUtils.cp_r(old_path, new_path)
      puts "   📁 Copied #{old_path} -> #{new_path}"
    end
    
    # Update the product's image field
    product.update_column(:image, expected_image)
    puts "   ✅ Updated database: Product ##{product.id} -> #{expected_image}"
    
    fixed_count += 1
  else
    puts "⚠️  No image mapping found for: #{product.name}"
  end
end

puts "\n🎉 Fixed #{fixed_count} product images!"
puts "Images should now load properly in the application."