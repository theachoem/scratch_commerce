class ShippingRateTaxRate < ApplicationRecord
  belongs_to :tax_rate
  belongs_to :shipping_rate
end
