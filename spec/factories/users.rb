FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { "test@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
