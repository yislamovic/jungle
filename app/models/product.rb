class Product < ApplicationRecord

  monetize :price_cents, numericality: {greater_than: 0}, allow_nil: false

  belongs_to :category

  validates :name, presence: true
  validates :price, presence: true
  validates :quantity, presence: true
  validates :category, presence: true

  def image_url
    return "/images/#{image_filename}" if image_filename.present?
    "/images/placeholder.jpg"
  end

end
