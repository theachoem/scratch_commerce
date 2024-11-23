class Property < ApplicationRecord
  enum :attr_type, { string: 0, integer: 1, float: 2, boolean: 3 }, prefix: true

  has_many :product_properties
  has_many :products, through: :product_properties

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :presentation, presence: true

  before_validation -> { self.name = self.name.downcase if name.present? }
end
