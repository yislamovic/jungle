#!/usr/bin/env ruby
# Fix images by using existing thumbnail files as originals

puts "🔧 Fixing images by using existing thumbnail files..."

# Current products and their expected images
products_and_images = [
  { id: 29, name: "Men's Classy Shirt", file: "apparel1.jpg", source_dir: 1 },
  { id: 30, name: "Women's Zebra Pants", file: "apparel2.jpg", source_dir: 2 },
  { id: 31, name: "Hipster Hat", file: "apparel3.jpg", source_dir: 3 },
  { id: 32, name: "Hipster Socks", file: "apparel4.jpg", source_dir: 4 },
  { id: 33, name: "Modern Skateboards", file: "electronics1.jpg", source_dir: 7 },
  { id: 34, name: "Hotdog Slicer", file: "electronics2.jpg", source_dir: 8 },
  { id: 35, name: "World's Largest Smartwatch", file: "electronics3.jpg", source_dir: 9 },
  { id: 36, name: "Optimal Sleeping Bed", file: "furniture1.jpg", source_dir: 10 },
  { id: 37, name: "Electric Chair", file: "furniture2.jpg", source_dir: 11 },
  { id: 38, name: "Red Bookshelf", file: "furniture3.jpg", source_dir: 12 }
]

fixed_count = 0

products_and_images.each do |item|
  product = Product.find_by(id: item[:id])
  next unless product
  
  puts "\n🔄 Processing #{product.name}:"
  
  # Path to source directory with existing thumbnails
  source_dir = Rails.root.join('public', 'uploads', 'product', 'image', item[:source_dir].to_s)
  target_dir = Rails.root.join('public', 'uploads', 'product', 'image', item[:id].to_s)
  
  if Dir.exist?(source_dir)
    # Copy entire directory structure if target doesn't exist
    if !Dir.exist?(target_dir)
      puts "   📁 Copying #{source_dir} -> #{target_dir}"
      FileUtils.cp_r(source_dir, target_dir)
    end
    
    # Create original file from thumbnail if it doesn't exist
    original_file = target_dir.join(item[:file])
    thumb_file = target_dir.join('thumb', "thumb_#{item[:file]}")
    
    if File.exist?(thumb_file) && !File.exist?(original_file)
      puts "   📷 Creating original from thumbnail: #{item[:file]}"
      FileUtils.cp(thumb_file, original_file)
    end
    
    # Update database
    product.update_column(:image, item[:file])
    puts "   ✅ Updated database: Product ##{product.id} -> #{item[:file]}"
    
    fixed_count += 1
  else
    puts "   ⚠️  Source directory not found: #{source_dir}"
  end
end

puts "\n🎉 Fixed #{fixed_count} product images!"

# Verify the fix worked
puts "\n🔍 Verification:"
Product.all.each do |p|
  if p.image.present?
    puts "✅ #{p.name}: #{p.image.url}"
  else  
    puts "❌ #{p.name}: No image"
  end
end