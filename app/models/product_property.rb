class ProductProperty < ApplicationRecord
  acts_as_list scope: :property

  belongs_to :product
  belongs_to :property
end
