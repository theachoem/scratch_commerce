class Property < ApplicationRecord
  has_many :product_properties
  has_many :products, through: :product_properties

  validates :name, :presentation, presence: true
end
