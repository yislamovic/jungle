# Fix for Rails 6.1 + Ruby 3.1 Logger issue
# This must be loaded before ActiveSupport loads

require 'logger'

# Override the problematic method in ActiveSupport
if defined?(ActiveSupport::LoggerThreadSafeLevel)
  module ActiveSupport
    module LoggerThreadSafeLevel
      def self.included(base)
        # Ensure Logger constants are available
        if defined?(::Logger)
          ::Logger::Severity.constants.each do |severity|
            level = ::Logger::Severity.const_get(severity)
            base.const_set(severity, level) unless base.const_defined?(severity)
          end
        end
      end
    end
  end
end