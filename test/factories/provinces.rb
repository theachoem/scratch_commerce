FactoryBot.define do
  factory :province, class: Province.name do
    name { "Phnom Penh" }
    abbr { "PP" }
    country
  end
end
