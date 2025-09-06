class SetupController < ApplicationController
  # Skip any authentication for this setup route
  skip_before_action :verify_authenticity_token, only: [:database]

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
end