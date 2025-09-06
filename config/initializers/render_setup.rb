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
          Rails.application.load_seed
          Rails.logger.info "Database seeding completed"
          
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
        
        # Run seeds
        Rails.application.load_seed
        Rails.logger.info "Database seeding completed"
        
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