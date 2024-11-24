FactoryBot.define do
  factory :order, class: Order.name do
    state { "cart" }
    currency { "USD" }
    channel { "web" }
    association :store
  end
end
