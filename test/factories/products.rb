FactoryBot.define do
  factory :product, class: Product.name do
    sequence(:name) { |n| "Product ##{n} - #{Kernel.rand(9999)}" }
    status { :draft }
    description { "As seen on TV!" }
    available_on { 1.year.ago }
    deleted_at { nil }
    merchant
  end
end
