FactoryBot.define do
  sequence(:random_float) { BigDecimal("#{rand(200)}.#{rand(99)}") }

  factory :variant, class: Variant.name do
    markup { 19.99 }
    cost_price { 17.00 }
    currency { "USD" }
    deleted_at { nil }
    product
  end
end
