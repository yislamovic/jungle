module DemoSession
  extend ActiveSupport::Concern

  included do
    before_action :initialize_demo_session
  end

  private

  def initialize_demo_session
    # Initialize session stores for demo mode
    session[:deleted_product_ids] ||= []
    session[:added_products] ||= []

    # Clean up old session data (optional - Rails handles this automatically)
    # Session expires when browser closes
  end

  # Get all visible products for current session
  # Excludes products "deleted" in this session
  # Includes base products + session-added products
  def session_products
    # Get base products (not deleted in this session)
    base_products = Product.where.not(id: session[:deleted_product_ids])

    # Add temporarily created products from session
    temp_products = session[:added_products].map do |product_data|
      # Create a Product instance but don't save it to DB
      Product.new(product_data.merge(id: product_data['id']))
    end

    # Combine base + temporary products
    base_products.to_a + temp_products
  end

  # Mark a product as deleted for this session only
  def session_delete_product(product_id)
    session[:deleted_product_ids] << product_id unless session[:deleted_product_ids].include?(product_id)
  end

  # Add a temporary product for this session only
  def session_add_product(product_params)
    # Generate a temporary negative ID to avoid conflicts
    temp_id = -(session[:added_products].length + 1)

    product_data = product_params.merge(
      'id' => temp_id,
      'created_at' => Time.current.to_s,
      'updated_at' => Time.current.to_s
    )

    session[:added_products] << product_data

    # Return a product instance
    Product.new(product_data.merge(id: temp_id))
  end

  # Check if a product is visible in current session
  def product_visible?(product_id)
    !session[:deleted_product_ids].include?(product_id)
  end
end
