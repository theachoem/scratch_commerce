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
  validates :markup, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  before_validation :set_currency, if: -> { currency.blank? }

  after_save :reload_option_texts_cache
  after_save :reload_total_inventory_units_cache
  after_save :reload_backorderable_cache

  after_discard do
    stock_items.discard_all
  end

  after_undiscard do
    stock_items.undiscard_all
  end

  def unit_price
    cost_price * markup / 100
  end

  def unit_price_for(currency)
    return unit_price if currency == self.currency
    throw :unsupported
  end

  def can_fulfill?(quantity, options = {})
    return true if backorderable?
    return true if total_inventory_units >= quantity

    false
  end

  def in_stock? = total_inventory_units > 0

  def reload_total_inventory_units_cache = delete_cache_if_exist(total_inventory_units_cache_key) && total_inventory_units
  def total_inventory_units_cache_key = "variant_#{id}_total_inventory_units"
  def total_inventory_units = Rails.cache.fetch(total_inventory_units_cache_key) { stock_items.sum(:inventory_units) }

  def reload_backorderable_cache = delete_cache_if_exist(backorderable_cache_key) && backorderable?
  def backorderable_cache_key = "variant_#{id}_backorderable"
  def backorderable? = Rails.cache.fetch(backorderable_cache_key) { stock_items.any?(&:backorderable) }

  def reload_option_texts_cache = delete_cache_if_exist(option_texts_cache_key) && option_texts
  def option_texts_cache_key = "variant_#{id}_option_texts"
  def option_texts
    Rails.cache.fetch(option_texts_cache_key) do
      option_values.includes(:option_type).map do |value|
        "#{value.option_type.presentation}: #{value.presentation}"
      end.join(", ")
    end
  end

  private

  def delete_cache_if_exist(cache_key)
    Rails.cache.delete(cache_key)
    true
  end

  def set_currency
    self.currency = Store.default.default_currency
  end
end
