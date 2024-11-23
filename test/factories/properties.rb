FactoryBot.define do
  factory :property, class: Property.name do
    sequence(:name) { |n| "cpu-#{n}" }
    presentation { "MyString" }
    attr_type { :string }
  end
end
