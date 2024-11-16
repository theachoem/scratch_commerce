class InventoryUnit < ApplicationRecord
  belongs_to :variant
  belongs_to :shipment
  belongs_to :line_item
end
