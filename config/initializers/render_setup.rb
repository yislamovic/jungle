# Auto-setup database for Render deployment
if Rails.env.production? && ENV['RENDER'].present?
  Rails.application.config.after_initialize do
    begin
      # Check if application tables exist (not just Rails system tables)
      existing_tables = ActiveRecord::Base.connection.data_sources
      app_tables_exist = existing_tables.include?('products') && existing_tables.include?('categories')
      
      if app_tables_exist
        # Check if we need to seed (no products exist)
        products_count = Product.count
        if products_count == 0
          Rails.logger.info "Database tables exist but no products found. Running seeds..."
          # Try with images first, fallback to simple seeds
          begin
            # Check if seed assets exist
            seed_assets_path = Rails.root.join('db', 'seed_assets')
            assets_exist = Dir.exist?(seed_assets_path) && Dir.glob(seed_assets_path.join('*.jpg')).any?
            
            if assets_exist
              Rails.logger.info "Seed assets found, running full seeds with images..."
              Rails.application.load_seed
              Rails.logger.info "Full database seeding completed"
            else
              Rails.logger.info "Seed assets not found, running simple seeds without images..."
              load Rails.root.join('db', 'simple_seeds.rb')
              Rails.logger.info "Simple database seeding completed"
            end
          rescue => seed_error
            Rails.logger.warn "Full seeding failed (#{seed_error.message}), trying simple seeds..."
            begin
              load Rails.root.join('db', 'simple_seeds.rb')
              Rails.logger.info "Simple database seeding completed as fallback"
            rescue => simple_seed_error
              Rails.logger.error "Both seeding methods failed: Full (#{seed_error.message}), Simple (#{simple_seed_error.message})"
              raise simple_seed_error
            end
          end
          
          final_count = Product.count
          Rails.logger.info "Seeded #{final_count} products"
        else
          Rails.logger.info "Application already has #{products_count} products, skipping seeds"
        end
        Rails.logger.info "Existing tables: #{existing_tables.join(', ')}"
      else
        Rails.logger.info "Setting up database for first deployment..."
        Rails.logger.info "Existing tables: #{existing_tables.join(', ')}"
        
        # Run migrations
        ActiveRecord::Tasks::DatabaseTasks.migrate
        Rails.logger.info "Database migrations completed"
        
        # Run seeds - try with images first, fallback to simple seeds
        begin
          # Check if seed assets exist
          seed_assets_path = Rails.root.join('db', 'seed_assets')
          assets_exist = Dir.exist?(seed_assets_path) && Dir.glob(seed_assets_path.join('*.jpg')).any?
          
          if assets_exist
            Rails.logger.info "Seed assets found, running full seeds with images..."
            Rails.application.load_seed
            Rails.logger.info "Full database seeding completed"
          else
            Rails.logger.info "Seed assets not found, running simple seeds without images..."
            load Rails.root.join('db', 'simple_seeds.rb')
            Rails.logger.info "Simple database seeding completed"
          end
        rescue => seed_error
          Rails.logger.warn "Full seeding failed (#{seed_error.message}), trying simple seeds..."
          begin
            load Rails.root.join('db', 'simple_seeds.rb')
            Rails.logger.info "Simple database seeding completed as fallback"
          rescue => simple_seed_error
            Rails.logger.error "Both seeding methods failed: Full (#{seed_error.message}), Simple (#{simple_seed_error.message})"
            raise simple_seed_error
          end
        end
        
        # Check final state
        final_tables = ActiveRecord::Base.connection.data_sources
        final_count = Product.count
        Rails.logger.info "Final tables: #{final_tables.join(', ')}"
        Rails.logger.info "Seeded #{final_count} products"
      end
    rescue => e
      Rails.logger.error "Database setup failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      # Don't crash the app if setup fails
    end
  end
end