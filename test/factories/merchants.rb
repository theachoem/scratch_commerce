FactoryBot.define do
  factory :merchant, class: Merchant.name do
    sequence(:name) { |n| "Merchant ##{n} - #{Kernel.rand(9999)}" }
    status { :draft }
    deleted_at { nil }
  end
end
