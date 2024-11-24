FactoryBot.define do
  factory :user, class: User.name do
    email { FFaker::Internet.email }
    password { "12345678" }
  end
end
