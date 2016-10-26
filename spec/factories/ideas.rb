FactoryGirl.define do
  factory :idea do
    association :author, factory: :user
    content { Faker::Lorem.paragraph }
  end
end
