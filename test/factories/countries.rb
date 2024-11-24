FactoryBot.define do
  factory :country, class: Country.name do
    iso_name { "KH" }
    iso { "KH" }
    iso3 { "KH" }
    name { "KH" }
    numcode { "+855" }
  end
end
