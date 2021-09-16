class Admin::DashboardController < ApplicationController
  def show
    @product_count = Product.all
    @categories_count = Category.all
  end
end
