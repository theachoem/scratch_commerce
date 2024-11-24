class LineItem < ApplicationRecord
  belongs_to :variant
  belongs_to :order

  has_many :adjustments, -> { order(:created_at) }, as: :adjustable, inverse_of: :adjustable, dependent: :destroy
end
