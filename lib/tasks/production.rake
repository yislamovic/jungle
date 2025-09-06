namespace :production do
  desc "Set up production environment with database, seeds, and images"
  task setup: :environment do
    puts "🚀 Setting up production environment..."
    
    # Ensure we're in production
    unless Rails.env.production?
      puts "❌ This task only runs in production environment"
      exit 1
    end
    
    begin
      # Create and migrate database
      puts "📊 Setting up database..."
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      
      # Run seeds
      puts "🌱 Running seeds..."
      Rake::Task['db:seed'].invoke
      
      # Setup images
      puts "🖼️  Setting up product images..."
      Rake::Task['production:setup_images'].invoke
      
      puts "✅ Production setup completed successfully!"
      
    rescue => e
      puts "❌ Production setup failed: #{e.message}"
      puts e.backtrace.join("\n")
      exit 1
    end
  end
  
  desc "Set up product images from seed assets"
  task setup_images: :environment do
    puts "🖼️  Setting up product images..."
    
    # Create uploads directory structure
    uploads_dir = Rails.root.join('public', 'uploads', 'product', 'image')
    FileUtils.mkdir_p(uploads_dir)
    puts "📁 Created uploads directory: #{uploads_dir}"
    
    # Product to image mapping
    products_and_images = [
      { id: 1, name: "Men's Classy Shirt", file: "apparel1.jpg" },
      { id: 2, name: "Women's Zebra Pants", file: "apparel2.jpg" },
      { id: 3, name: "Hipster Hat", file: "apparel3.jpg" },
      { id: 4, name: "Hipster Socks", file: "apparel4.jpg" },
      { id: 5, name: "Modern Skateboards", file: "electronics1.jpg" },
      { id: 6, name: "Hotdog Slicer", file: "electronics2.jpg" },
      { id: 7, name: "World's Largest Smartwatch", file: "electronics3.jpg" },
      { id: 8, name: "Optimal Sleeping Bed", file: "furniture1.jpg" },
      { id: 9, name: "Electric Chair", file: "furniture2.jpg" },
      { id: 10, name: "Red Bookshelf", file: "furniture3.jpg" }
    ]

    seed_assets_path = Rails.root.join('db', 'seed_assets')
    fixed_count = 0

    products_and_images.each do |item|
      product = Product.find_by(id: item[:id])
      next unless product
      
      puts "🔄 Processing #{product.name}..."
      
      # Create product image directory structure
      product_dir = uploads_dir.join(item[:id].to_s)
      FileUtils.mkdir_p(product_dir)
      FileUtils.mkdir_p(product_dir.join('thumb'))
      FileUtils.mkdir_p(product_dir.join('tiny'))
      
      # Source file from seed assets
      source_file = seed_assets_path.join(item[:file])
      
      if File.exist?(source_file)
        # Copy original image
        original_file = product_dir.join(item[:file])
        FileUtils.cp(source_file, original_file)
        puts "   📷 Created original: #{item[:file]}"
        
        # Create thumbnails using MiniMagick
        begin
          require 'mini_magick'
          
          # Create thumb version (300x300)
          thumb_file = product_dir.join('thumb', "thumb_#{item[:file]}")
          MiniMagick::Tool::Convert.new do |convert|
            convert << source_file.to_s
            convert.resize "300x300>"
            convert << thumb_file.to_s
          end
          puts "   🖼️  Created thumb (300x300)"
          
          # Create tiny version (100x100)  
          tiny_file = product_dir.join('tiny', "tiny_#{item[:file]}")
          MiniMagick::Tool::Convert.new do |convert|
            convert << source_file.to_s
            convert.resize "100x100>"
            convert << tiny_file.to_s
          end
          puts "   🖼️  Created tiny (100x100)"
          
        rescue => thumb_error
          puts "   ⚠️  Thumbnail creation failed: #{thumb_error.message}"
          # Fallback: copy original as thumbnails
          FileUtils.cp(source_file, product_dir.join('thumb', "thumb_#{item[:file]}"))
          FileUtils.cp(source_file, product_dir.join('tiny', "tiny_#{item[:file]}"))
          puts "   📷 Created thumbnails as copies of original"
        end
        
        # Update database
        product.update_column(:image, item[:file])
        puts "   ✅ Updated database: #{item[:file]}"
        
        fixed_count += 1
      else
        puts "   ❌ Source file not found: #{source_file}"
      end
    end

    puts "🎉 Set up #{fixed_count} product images!"
  end
  
  desc "Check production environment health"
  task health_check: :environment do
    puts "🏥 Running production health check..."
    
    # Check database connectivity
    begin
      ActiveRecord::Base.connection.execute("SELECT 1")
      puts "✅ Database: Connected"
    rescue => e
      puts "❌ Database: Failed (#{e.message})"
    end
    
    # Check products
    begin
      product_count = Product.count
      puts "✅ Products: #{product_count} found"
    rescue => e
      puts "❌ Products: Failed (#{e.message})"
    end
    
    # Check categories
    begin
      category_count = Category.count
      puts "✅ Categories: #{category_count} found"
    rescue => e
      puts "❌ Categories: Failed (#{e.message})"
    end
    
    # Check images
    begin
      products_with_images = Product.where.not(image: [nil, '']).count
      puts "✅ Product images: #{products_with_images}/#{Product.count} have images"
    rescue => e
      puts "❌ Product images: Failed (#{e.message})"
    end
    
    puts "🏥 Health check complete!"
  end
end