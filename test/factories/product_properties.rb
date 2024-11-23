FactoryBot.define do
  factory :product_property, class: ProductProperty.name do
    association :product
    association :property
    value { "MyString" }
    position { 1 }
  end
end
