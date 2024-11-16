class Variant < ApplicationRecord
  include SoftDeletable

  acts_as_list scope: :product

  belongs_to :product

  has_many :variant_images, -> { order(:position) }, as: :viewable, dependent: :destroy
  has_many :option_value_variants, -> { order(:position) }
  has_many :option_values, through: :option_value_variants
  has_many :stock_items
  has_many :stock_locations, through: :stock_items
  has_many :inventory_units
  has_many :line_items
  has_many :orders, through: :line_items

  validates :product, presence: true
  validates :cost_price, presence: true
  validates :markup, presence: true
  validates :cost_price, numericality: { greater_than_or_equal_to: 0 }
  validates :markup, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_currency

  after_save :clear_option_texts_cache

  after_discard do
    stock_items.discard_all
  end

  after_undiscard do
    stock_items.undiscard_all
  end

  def in_stock?
    stock_items.sum(:inventory_units) > 0
  end

  def backorderable?
    stock_items.any?(&:backorderable)
  end

  def clear_option_texts_cache = Rails.cache.delete(option_texts_cache_key)
  def option_texts_cache_key = "variant_#{id}_option_texts"
  def option_texts
    Rails.cache.fetch(option_texts_cache_key) do
      option_values.includes(:option_type).map do |value|
        "#{value.option_type.presentation}: #{value.presentation}"
      end.join(", ")
    end
  end

  private

  def set_currency
    self.currency = "USD" if currency.blank?
  end
end
