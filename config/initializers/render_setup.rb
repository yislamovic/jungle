# Auto-setup database for Render deployment
if Rails.env.production? && ENV['RENDER'].present?
  Rails.application.config.after_initialize do
    begin
      # Check if application tables exist (not just Rails system tables)
      existing_tables = ActiveRecord::Base.connection.data_sources
      app_tables_exist = existing_tables.include?('products') && existing_tables.include?('categories')
      
      unless app_tables_exist
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
        Rails.logger.info "Final tables: #{final_tables.join(', ')}"
      else
        Rails.logger.info "Application tables already exist, skipping setup"
        Rails.logger.info "Existing tables: #{existing_tables.join(', ')}"
      end
    rescue => e
      Rails.logger.error "Database setup failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      # Don't crash the app if setup fails
    end
  end
end