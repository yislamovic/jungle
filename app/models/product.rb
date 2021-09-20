class Product < ActiveRecord::Base

  monetize :price_cents, numericality: {greater_than: 0}, allow_nil: false
  mount_uploader :image, ProductImageUploader

  belongs_to :category

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category, presence: true

end
