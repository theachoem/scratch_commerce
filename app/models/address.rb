class Address < ApplicationRecord
  belongs_to :province
  belongs_to :country
end
