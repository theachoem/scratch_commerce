class Province < ApplicationRecord
  belongs_to :country

  has_many :addresses, dependent: :nullify
  has_many :stock_locations, dependent: :restrict_with_error
end
