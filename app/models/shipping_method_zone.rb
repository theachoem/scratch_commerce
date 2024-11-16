class ShippingMethodZone < ApplicationRecord
  belongs_to :shipping_method
  belongs_to :zone
end
