class Country < ApplicationRecord
  has_many :provinces
  has_many :stock_locations, through: :provinces
end
