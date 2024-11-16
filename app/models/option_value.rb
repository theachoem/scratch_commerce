class OptionValue < ApplicationRecord
  acts_as_list scope: :option_type

  belongs_to :option_type

  has_many :option_value_variants, -> { order(:position) }
  has_many :variants, through: :option_value_variants

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :presentation, presence: true

  before_validation -> { self.name = self.name.downcase if name.present? }
end
