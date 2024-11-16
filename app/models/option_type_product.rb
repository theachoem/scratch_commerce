class OptionTypeProduct < ApplicationRecord
  belongs_to :option_type
  belongs_to :product
end
