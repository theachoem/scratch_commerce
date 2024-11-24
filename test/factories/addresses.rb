FactoryBot.define do
  factory :address, class: Address.name do
    first_name { "Sahakom" }
    last_name { "Grow" }
    address1 { "21st, Kandal" }
    address2 { "Near Meakra River" }
    phone_number { "12345678" }

    province
    country
  end
end
