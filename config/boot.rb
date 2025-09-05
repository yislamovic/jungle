ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' # Set up gems listed in the Gemfile.

# Fix for Rails 6.1 + Ruby 3.1 Logger issue
require 'logger'
