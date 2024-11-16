class Asset < ApplicationRecord
  belongs_to :viewable, polymorphic: true
end
