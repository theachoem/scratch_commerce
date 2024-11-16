class TaxonProduct < ApplicationRecord
  belongs_to :product
  belongs_to :taxon
end
