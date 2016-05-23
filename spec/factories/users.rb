FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    confirmed_at Time.now

    trait :with_parcels do
      transient do
        parcels_count 3
      end
      after(:create) do |user, evaluator|
        create_list(:parcel, evaluator.parcels_count, sender: user)
      end
    end

    trait :admin do
      role 'admin'
    end

    trait :employee do
      role 'employee'
    end
  end
end
