class ShippingRate < ApplicationRecord
  belongs_to :shipping_method
  belongs_to :shipment
end
