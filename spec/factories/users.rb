FactoryBot.define do
  factory :user do
    email { "john_doe@example.com" }
    name { Faker::Name.name }
  end
end
