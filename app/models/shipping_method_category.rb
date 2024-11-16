class ShippingMethodCategory < ApplicationRecord
  belongs_to :shipping_category
  belongs_to :shipping_method
end
