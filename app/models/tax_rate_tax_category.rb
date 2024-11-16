class TaxRateTaxCategory < ApplicationRecord
  belongs_to :tax_rate
  belongs_to :tax_category
end
