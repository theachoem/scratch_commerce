class StockLocation < ApplicationRecord
  belongs_to :province, optional: false
  belongs_to :country, optional: false
end
