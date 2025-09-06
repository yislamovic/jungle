#!/usr/bin/env ruby
# Fix disconnected images by linking existing files to database records

puts "🔧 Fixing image connections between database and filesystem..."

# Mapping of expected product IDs to their image files
image_mappings = {
  1 => 'apparel1.jpg',
  2 => 'apparel2.jpg', 
  3 => 'apparel3.jpg',
  4 => 'apparel4.jpg',
  5 => 'apparel5.jpg',
  6 => 'apparel6.jpg',
  7 => 'electronics1.jpg',
  8 => 'electronics2.jpg', 
  9 => 'electronics3.jpg',
  10 => 'furniture1.jpg',
  11 => 'furniture2.jpg',
  12 => 'furniture3.jpg'
}

fixed_count = 0

image_mappings.each do |product_id, filename|
  product = Product.find_by(id: product_id)
  
  if product
    # Check if the image file actually exists
    image_dir = Rails.root.join('public', 'uploads', 'product', 'image', product_id.to_s)
    image_file = Dir.glob(image_dir.join('**', filename)).first
    
    if image_file
      # Update the product's image field to point to the existing file
      product.update_column(:image, filename)
      puts "✅ Fixed Product ##{product_id} (#{product.name}) -> #{filename}"
      fixed_count += 1
    else
      puts "⚠️  Image file not found for Product ##{product_id}: #{filename}"
    end
  else
    puts "⚠️  Product ##{product_id} not found in database"
  end
end

puts "\n🎉 Fixed #{fixed_count} product images!"
puts "Images should now load properly in the application."