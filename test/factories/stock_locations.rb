FactoryBot.define do
  factory :stock_location, class: StockLocation.name do
    name { "Sahakom Phnom Penh" }
    status { 0 }
    province
    country
  end
end
