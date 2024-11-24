class Shipment < ApplicationRecord
  belongs_to :order
  belongs_to :stock_location

  has_many :adjustments, -> { order(:created_at) }, as: :adjustable, inverse_of: :adjustable, dependent: :destroy
end
