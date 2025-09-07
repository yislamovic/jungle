class Product < ApplicationRecord

  monetize :price_cents, numericality: {greater_than: 0}, allow_nil: false

  belongs_to :category

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category, presence: true

  def image_asset_name
    return image_filename if image_filename.present?
    "placeholder.jpg"
  end

end
