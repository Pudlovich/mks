FactoryGirl.define do
  factory :operation do
    parcel

    trait :order_created do
      kind 'order_created'
    end

    trait :order_accepted do
      kind 'order_accepted'
      user { FactoryGirl.create(:user, :employee) }
    end
    
    trait :order_rejected do
      kind 'order_rejected'
      user { FactoryGirl.create(:user, :employee) }
    end

    trait :parcel_picked_up do
      kind 'parcel_picked_up'
      user { FactoryGirl.create(:user, :employee) }
    end

    trait :parcel_in_sorting_facility do
      kind 'parcel_in_sorting_facility'
      user { FactoryGirl.create(:user, :employee) }
    end

    trait :parcel_in_transit do
      kind 'parcel_in_transit'
      user { FactoryGirl.create(:user, :employee) }
    end

    trait :parcel_in_delivery do
      kind 'parcel_in_delivery'
      user { FactoryGirl.create(:user, :employee) }
    end

    trait :parcel_delivered do
      kind 'parcel_delivered'
      user { FactoryGirl.create(:user, :employee) }
    end

    trait :with_place do
      place { Faker::Address.city }
    end

    trait :with_additional_info do
      additional_info { Faker::StarWars.quote }
    end
  end
end
