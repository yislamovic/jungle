require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    it "is valid with valid attributes" do
      @category = Category.create(name: "Books")
      @product = Product.create(name: "Communist manifesto", price: 0, 
      quantity: 10, category: @category)
      expect(@category).to be_valid
    end
    it "should fail validation if name is nil" do
      @category = Category.create(name: "Toys")
      @product = Product.create(name: nil, price: 10, 
      quantity: 10, category: @category)
      expect(@product).to_not be_valid
    end
    it "should fail validation if price is nil" do
      @category = Category.create(name: "Animals")
      @product = Product.create(name: "Tiger", price: nil, 
      quantity: 10, category: @category)
      expect(@product).to_not be_valid
    end
    it "should fail validation if quantity is nil" do
      @category = Category.create(name: "Animals")
      @product = Product.create(name: "Tiger", price: 10, 
      quantity: nil, category: @category)
      expect(@product).to_not be_valid
    end
    it "should fail validation if category is nil" do
      @product = Product.create(name: "Tiger", price: 10, 
      quantity: 10, category: nil)
      expect(@product).to_not be_valid
    end
  end  
end

