class StockItem < ApplicationRecord
  belongs_to :stock_location
  belongs_to :variant
end
