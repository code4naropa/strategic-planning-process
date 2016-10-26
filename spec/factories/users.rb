FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name { Faker::Name.name }
    password { Faker::Internet.password(10, 50) }
    last_seen_at nil
    confirmed_registration true
  end
end
