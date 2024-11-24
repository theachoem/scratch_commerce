class StockItem < ApplicationRecord
  belongs_to :stock_location
  belongs_to :variant

  after_commit :reload_variant_total_inventory_units_cache
  after_commit :reload_variant_backorderable_cache

  def reload_variant_total_inventory_units_cache = variant.reload_total_inventory_units_cache
  def reload_variant_backorderable_cache = variant.reload_backorderable_cache
end
