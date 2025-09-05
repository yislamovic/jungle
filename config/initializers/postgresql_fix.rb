# Fix for Rails 6.1 + Ruby 3.1 Logger compatibility issue

# Ensure Logger is properly loaded before ActiveSupport tries to use it
require 'logger' unless defined?(Logger)

# Fix for Rails 6.1 Logger constants issue with Ruby 3.1
if RUBY_VERSION >= "3.1.0" && Rails.version.starts_with?("6.1")
  begin
    # Patch ActiveSupport's logger thread safe level to handle Ruby 3.1
    module ActiveSupport
      module LoggerThreadSafeLevel
        def self.included(base)
          # Ensure Logger::Severity is available
          unless defined?(::Logger::Severity)
            require 'logger'
          end
          
          # Make sure all severity constants exist
          if defined?(::Logger::Severity)
            ::Logger::Severity.constants.each do |severity|
              level = ::Logger::Severity.const_get(severity)
              base.const_set(severity, level) unless base.const_defined?(severity)
            end
          end
        end
      end
    end
  rescue => e
    puts "Logger fix failed: #{e.message}"
  end
end