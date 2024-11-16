class OptionValue < ApplicationRecord
  acts_as_list scope: :option_type

  belongs_to :option_type

  has_many :option_value_variants, -> { order(:position) }
  has_many :variants, through: :option_value_variants

  validates :name, presence: true, uniqueness: { scope: :option_type_id, case_sensitive: false }
  validates :presentation, presence: true

  before_validation -> { self.name = self.name.downcase if name.present? }

  after_save :clear_variant_option_texts_cache

  def clear_variant_option_texts_cache
    variants.find_each(&:clear_option_texts_cache)
  end
end
