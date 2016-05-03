FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at Time.now

    trait :with_parcel do
      after(:create) do |user|
        create(:parcel, sender: user)
      end
    end
  end
end
