FactoryBot.define do
  factory :taxon, class: Taxon.name do
    sequence(:name) { |n| "Taxon ##{n} - #{Kernel.rand(9999)}" }
    taxonomy
  end
end
