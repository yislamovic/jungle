class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  def new
    @catagory = Category.new
  end 
  def create
    @catagory = Category.new(params[:name])
    if @catagory.save
      redirect_to [:admin, :categories], notice: 'Category created!'
    else
      render :new
    end
  end  
end
