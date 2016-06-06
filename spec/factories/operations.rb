FactoryGirl.define do
  factory :operation do
    parcel

    trait :order_accepted do
      kind 'order_accepted'
      user { FactoryGirl.create(:user, :employee) }
    end
    
    trait :order_rejected do
      kind 'order_accepted'
      user { FactoryGirl.create(:user, :employee) }
    end
  end
end
