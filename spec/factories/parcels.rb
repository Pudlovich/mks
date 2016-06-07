FactoryGirl.define do
  factory :parcel do
    width { Faker::Number.between(1, 100) }
    height { Faker::Number.between(1, 100) }
    depth { Faker::Number.between(1, 100) }
    weight { Faker::Number.decimal(1,2) }

    recipient_info { FactoryGirl.create(:recipient_info) }
    sender_info { FactoryGirl.create(:sender_info) }

    trait :with_name do
      name { Faker::Commerce.product_name }
    end

    trait :with_sender do
      sender { FactoryGirl.create(:user) }
    end

    trait :invalid do
      width nil
    end

    trait :accepted do
      after(:create) do |parcel|
        FactoryGirl.create(:operation, :order_accepted, parcel: parcel)
      end
    end

    trait :rejected do
      after(:create) do |parcel|
        FactoryGirl.create(:operation, :order_rejected, parcel: parcel)
      end
    end
  end
end
