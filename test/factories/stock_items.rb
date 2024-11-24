FactoryBot.define do
  factory :stock_item, class: StockItem.name do
    stock_location
    variant
    inventory_units { 3 }
    printed_units { 0 }
    backorderable { false }
    deleted_at { nil }
  end
end
