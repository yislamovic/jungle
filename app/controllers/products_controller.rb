class ProductsController < ApplicationController
  include DemoSession

  def index
    # Show session-filtered products (excludes session-deleted products)
    @products = session_products.sort_by(&:created_at).reverse
  end

  def show
    @product = Product.find params[:id]

    # Check if product is visible in current session
    unless product_visible?(@product.id)
      redirect_to root_path, alert: 'Product not found'
    end
  end

end
