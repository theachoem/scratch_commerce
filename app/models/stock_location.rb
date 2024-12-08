class StockLocation < ApplicationRecord
  enum :status, [ :draft, :active, :archived ], default: :draft

  belongs_to :province, optional: false
  belongs_to :country, optional: false

  has_many :stock_items

  before_validation :set_country, if: -> { country_id.blank? }

  private

  def set_country
    self.country_id = province.country_id
  end
end
