class SetupController < ApplicationController
  # Skip any authentication for this setup route
  skip_before_action :verify_authenticity_token, only: [:database, :diagnostic, :seed, :simple_seed]

  def database
    if Rails.env.production?
      begin
        # Check if application tables exist (not just Rails system tables)
        existing_tables = ActiveRecord::Base.connection.data_sources
        app_tables_exist = existing_tables.include?('products') && existing_tables.include?('categories')
        
        if app_tables_exist
          render plain: "✅ Database already set up! Tables exist: #{existing_tables.join(', ')}"
        else
          # Run migrations
          ActiveRecord::Tasks::DatabaseTasks.migrate
          
          # Run seeds
          Rails.application.load_seed
          
          # Check tables after setup
          new_tables = ActiveRecord::Base.connection.data_sources
          render plain: "✅ Database setup completed successfully! Migrations and seeds have been run.\nTables now: #{new_tables.join(', ')}"
        end
      rescue => e
        render plain: "❌ Database setup failed: #{e.message}\n\nFull error:\n#{e.backtrace.join("\n")}"
      end
    else
      render plain: "❌ This endpoint only works in production environment"
    end
  end

  def diagnostic
    if Rails.env.production?
      diagnostics = []
      
      begin
        # Test database connection
        ActiveRecord::Base.connection.execute("SELECT 1")
        diagnostics << "✅ Database connection: OK"
        
        # Check if tables exist
        tables = ActiveRecord::Base.connection.data_sources
        diagnostics << "✅ Tables (#{tables.count}): #{tables.join(', ')}"
        
        # Test model loading
        Product.first
        diagnostics << "✅ Product model: OK"
        
        Category.first  
        diagnostics << "✅ Category model: OK"
        
        # Test routes
        diagnostics << "✅ Routes loaded: #{Rails.application.routes.routes.count} routes"
        
        # Test basic functionality that home page needs
        products_count = Product.count
        categories_count = Category.count
        diagnostics << "✅ Data check: #{products_count} products, #{categories_count} categories"
        
      rescue => e
        diagnostics << "❌ Error: #{e.message}"
        diagnostics << "❌ Backtrace: #{e.backtrace.first(10).join("\n")}"
      end
      
      render plain: diagnostics.join("\n")
    else
      render plain: "❌ This endpoint only works in production environment"
    end
  end

  def seed
    if Rails.env.production?
      begin
        # Check seed assets directory
        seed_assets_path = Rails.root.join('db', 'seed_assets')
        assets_exist = Dir.exist?(seed_assets_path)
        asset_files = assets_exist ? Dir.glob(seed_assets_path.join('*.jpg')).map { |f| File.basename(f) } : []
        
        diagnostics = []
        diagnostics << "🔍 Seed assets directory exists: #{assets_exist}"
        diagnostics << "📁 Seed assets path: #{seed_assets_path}"
        diagnostics << "🖼️  Asset files found: #{asset_files.join(', ')}" if asset_files.any?
        diagnostics << "❌ No asset files found!" if asset_files.empty?
        
        # Check current state
        products_before = Product.count
        categories_before = Category.count
        diagnostics << "📊 Before seeding: #{categories_before} categories, #{products_before} products"
        
        # Try with images first, fallback to simple seeds
        begin
          # Check if seed assets exist
          seed_assets_path = Rails.root.join('db', 'seed_assets')
          assets_exist = Dir.exist?(seed_assets_path) && Dir.glob(seed_assets_path.join('*.jpg')).any?
          
          if assets_exist
            diagnostics << "🖼️  Running full seeds with images..."
            Rails.application.load_seed
            diagnostics << "✅ Full database seeding completed"
          else
            diagnostics << "📁 Seed assets not found, running simple seeds without images..."
            load Rails.root.join('db', 'simple_seeds.rb')
            diagnostics << "✅ Simple database seeding completed"
          end
        rescue => seed_error
          diagnostics << "⚠️  Full seeding failed (#{seed_error.message}), trying simple seeds..."
          begin
            load Rails.root.join('db', 'simple_seeds.rb')
            diagnostics << "✅ Simple database seeding completed as fallback"
          rescue => simple_seed_error
            diagnostics << "❌ Both seeding methods failed: Full (#{seed_error.message}), Simple (#{simple_seed_error.message})"
            raise simple_seed_error
          end
        end
        
        # Check results
        products_after = Product.count
        categories_after = Category.count
        diagnostics << "📊 After seeding: #{categories_after} categories, #{products_after} products"
        
        render plain: diagnostics.join("\n")
      rescue => e
        render plain: "❌ Seeding failed: #{e.message}\n\nFull error:\n#{e.backtrace.join("\n")}"
      end
    else
      render plain: "❌ This endpoint only works in production environment"
    end
  end

  def simple_seed
    if Rails.env.production?
      begin
        # Load simple seeds without images
        load Rails.root.join('db', 'simple_seeds.rb')
        
        # Check results
        products_count = Product.count
        categories_count = Category.count
        
        render plain: "✅ Simple seeds completed successfully!\nCreated: #{categories_count} categories, #{products_count} products (without images)"
      rescue => e
        render plain: "❌ Simple seeding failed: #{e.message}\n\nFull error:\n#{e.backtrace.join("\n")}"
      end
    else
      render plain: "❌ This endpoint only works in production environment"
    end
  end

  def fix_images
    if Rails.env.production?
      begin
        diagnostics = []
        diagnostics << "🔧 Running image fix script..."
        
        # Run the image fix inline
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
          
          # Path to source directory with existing thumbnails
          source_dir = Rails.root.join('public', 'uploads', 'product', 'image', item[:source_dir].to_s)
          target_dir = Rails.root.join('public', 'uploads', 'product', 'image', item[:id].to_s)
          
          if Dir.exist?(source_dir)
            # Copy entire directory structure if target doesn't exist
            if !Dir.exist?(target_dir)
              FileUtils.cp_r(source_dir, target_dir)
              diagnostics << "📁 Copied images for #{product.name}"
            end
            
            # Ensure all 3 image versions exist (original, thumb, tiny)
            original_file = target_dir.join(item[:file])
            thumb_file = target_dir.join('thumb', "thumb_#{item[:file]}")
            tiny_file = target_dir.join('tiny', "tiny_#{item[:file]}")
            
            # Create original file from best available source
            if !File.exist?(original_file)
              if File.exist?(thumb_file)
                FileUtils.cp(thumb_file, original_file)
                diagnostics << "📷 Created original from thumb: #{item[:file]}"
              elsif File.exist?(tiny_file)
                FileUtils.cp(tiny_file, original_file)
                diagnostics << "📷 Created original from tiny: #{item[:file]}"
              else
                diagnostics << "⚠️  No source image found for #{item[:file]}"
              end
            end
            
            # Verify all versions exist
            versions_exist = []
            versions_exist << "original" if File.exist?(original_file)
            versions_exist << "thumb" if File.exist?(thumb_file) 
            versions_exist << "tiny" if File.exist?(tiny_file)
            diagnostics << "📂 Available versions for #{item[:file]}: #{versions_exist.join(', ')}"
            
            # Update database
            product.update_column(:image, item[:file])
            diagnostics << "✅ Fixed #{product.name}"
            
            fixed_count += 1
          else
            diagnostics << "⚠️  No images found for #{product.name}"
          end
        end

        diagnostics << "\n🎉 Fixed #{fixed_count} product images!"
        
        # Verify the fix worked
        diagnostics << "\n🔍 Verification:"
        Product.all.each do |p|
          if p.image.present?
            diagnostics << "✅ #{p.name}: Has image"
          else  
            diagnostics << "❌ #{p.name}: No image"
          end
        end
        
        render plain: diagnostics.join("\n")
      rescue => e
        render plain: "❌ Image fix failed: #{e.message}\n\nFull error:\n#{e.backtrace.join("\n")}"
      end
    else
      render plain: "❌ This endpoint only works in production environment"
    end
  end

  def check_images
    if Rails.env.production?
      begin
        diagnostics = []
        diagnostics << "🔍 Checking image directories and files..."
        
        # Check what image directories exist
        uploads_path = Rails.root.join('public', 'uploads', 'product', 'image')
        diagnostics << "📁 Uploads path: #{uploads_path}"
        
        if Dir.exist?(uploads_path)
          directories = Dir.glob(uploads_path.join('*')).select { |d| File.directory?(d) }
          diagnostics << "📂 Found #{directories.count} directories:"
          
          directories.each do |dir|
            dir_name = File.basename(dir)
            files = Dir.glob(File.join(dir, '**', '*')).select { |f| File.file?(f) }
            image_files = files.select { |f| f.match?(/\.(jpg|jpeg|png)$/i) }
            diagnostics << "   #{dir_name}/: #{image_files.count} images (#{image_files.map { |f| File.basename(f) }.join(', ')})"
          end
        else
          diagnostics << "❌ Uploads directory doesn't exist!"
        end
        
        # Check seed assets
        seed_assets_path = Rails.root.join('db', 'seed_assets')
        if Dir.exist?(seed_assets_path)
          seed_files = Dir.glob(seed_assets_path.join('*.jpg')).map { |f| File.basename(f) }
          diagnostics << "🌱 Seed assets: #{seed_files.join(', ')}"
        else
          diagnostics << "❌ Seed assets directory doesn't exist"
        end
        
        # Check current products
        diagnostics << "\n📊 Current products:"
        Product.all.each do |p|
          diagnostics << "   Product ##{p.id}: #{p.name} (image: #{p.image || 'none'})"
        end
        
        render plain: diagnostics.join("\n")
      rescue => e
        render plain: "❌ Image check failed: #{e.message}\n\nFull error:\n#{e.backtrace.join("\n")}"
      end
    else
      render plain: "❌ This endpoint only works in production environment"
    end
  end
end