# Auto-setup database for Render deployment
if Rails.env.production? && ENV['RENDER'].present?
  Rails.application.config.after_initialize do
    begin
      # Check if database exists and has tables
      unless ActiveRecord::Base.connection.data_sources.any?
        Rails.logger.info "Setting up database for first deployment..."
        
        # Run migrations
        ActiveRecord::Tasks::DatabaseTasks.migrate
        Rails.logger.info "Database migrations completed"
        
        # Run seeds
        Rails.application.load_seed
        Rails.logger.info "Database seeding completed"
      else
        Rails.logger.info "Database already exists, skipping setup"
      end
    rescue => e
      Rails.logger.error "Database setup failed: #{e.message}"
      # Don't crash the app if setup fails
    end
  end
end