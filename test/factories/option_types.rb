FactoryBot.define do
  factory :option_type, class: OptionType.name do
    sequence(:name) { |n| "foo-size-#{n}" }
    presentation { "Size" }
  end
end
