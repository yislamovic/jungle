class Admin::CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end
  def new
    @catagory = Category.new
  end 
  def create
    @catagory = Category.new(catagory_params)
    if @catagory.save
      redirect_to [:admin, :categories], notice: 'Category created!'
    else
      render :new
    end
  end  
  private
  def catagory_params
    params.require(:category).permit(:name)
  end
end
