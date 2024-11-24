FactoryBot.define do
  factory :store, class: Store.name do
    name { "Sahakom" }
    default_currency { "USD" }
    is_default { true }
  end
end
