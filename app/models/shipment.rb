class Shipment < ApplicationRecord
  belongs_to :order
  belongs_to :stock_location
end
