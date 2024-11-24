class Province < ApplicationRecord
  belongs_to :country

  has_many :address, dependent: :nullify
end
