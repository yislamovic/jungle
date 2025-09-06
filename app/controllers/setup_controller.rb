class SetupController < ApplicationController
  # Skip any authentication for this setup route
  skip_before_action :verify_authenticity_token, only: [:database, :diagnostic]

  def database
    if Rails.env.production?
      begin
        # Check if tables already exist
        tables_exist = ActiveRecord::Base.connection.data_sources.any?
        
        if tables_exist
          render plain: "✅ Database already set up! Tables exist: #{ActiveRecord::Base.connection.data_sources.join(', ')}"
        else
          # Run migrations
          ActiveRecord::Tasks::DatabaseTasks.migrate
          
          # Run seeds
          Rails.application.load_seed
          
          render plain: "✅ Database setup completed successfully! Migrations and seeds have been run."
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
end