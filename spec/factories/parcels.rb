FactoryGirl.define do
  factory :parcel do
    width { Faker::Number.between(1, 100) }
    height { Faker::Number.between(1, 100) }
    depth { Faker::Number.between(1, 100) }
    weight { Faker::Number.decimal(1,2) }

    trait :with_name do
      name { Faker::Commerce.product_name }
    end

    trait :with_sender do
      sender { FactoryGirl.create(:user) }
    end

    trait :invalid do
      width nil
    end
  end
end