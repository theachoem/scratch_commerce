class Adjustment < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :adjustable, polymorphic: true
  belongs_to :order
end
