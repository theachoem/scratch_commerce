FactoryBot.define do
  factory :taxonomy, class: Taxonomy.name do
    sequence(:name) { |n| "Taxonomy ##{n} - #{Kernel.rand(9999)}" }
  end
end
