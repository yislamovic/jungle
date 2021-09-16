class AboutController < ApplicationController
  def index
    @products = Product.all
    @category = Category.all
  end  
end
