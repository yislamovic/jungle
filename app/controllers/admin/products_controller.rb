class Admin::ProductsController < ApplicationController
  include DemoSession

  # No authentication needed for demo mode - this is a portfolio demo app
  # http_basic_authenticate_with name: ENV["HTTP_BASIC_USER"], password: ENV["HTTP_BASIC_PASSWORD"]

  def index
    # Show session-filtered products
    @products = session_products.sort_by { |p| p.id.to_i }.reverse
  end

  def new
    @product = Product.new
  end

  def create
    # Create product in session only (demo mode)
    @product = session_add_product(product_params.to_h)

    redirect_to [:admin, :products], notice: 'Product created! (Demo - will reset on page refresh)'
  end

  def destroy
    product_id = params[:id].to_i

    # Mark product as deleted in session only (demo mode)
    session_delete_product(product_id)

    redirect_to [:admin, :products], notice: 'Product deleted! (Demo - will reset on page refresh)'
  end

  private

  def product_params
    params.require(:product).permit(
      :name,
      :description,
      :category_id,
      :quantity,
      :image,
      :price
    )
  end
end
