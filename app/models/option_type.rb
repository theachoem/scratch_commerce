class OptionType < ApplicationRecord
  acts_as_list
  default_scope -> { order(:position) }

  has_many :option_type_products
  has_many :products, through: :option_type_products
  has_many :option_values
  has_many :variants, through: :option_values

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :presentation, presence: true

  before_validation -> { self.name = self.name.downcase if name.present? }

  after_commit :reload_variant_option_texts_cache

  def reload_variant_option_texts_cache
    variants.find_each(&:reload_option_texts_cache)
  end
end
