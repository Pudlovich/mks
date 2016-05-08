FactoryGirl.define do
  factory :recipient_info do
    email { Faker::Internet.email }
    contact_name { Faker::Name.name }
    zip_code { Faker::Address.zip_code }
    address { Faker::Address.street_address }
    city { Faker::Address.city }
    phone_number { Faker::PhoneNumber.phone_number }
    residential false

    trait :with_company_name do
      company_name { Faker::Company.name }
    end

    trait :residential do
      residential true
    end

    trait :with_other_info do
      other_info { Faker::StarWars.quote }
    end
  end
end
