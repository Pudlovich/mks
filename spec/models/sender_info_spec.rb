require 'rails_helper'

RSpec.describe SenderInfo, type: :model do
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:contact_name) }
  it { is_expected.to validate_presence_of(:zip_code) }
  it { is_expected.to validate_presence_of(:address) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:phone_number) }
  it { is_expected.not_to validate_presence_of(:company_name) }
  it { is_expected.not_to validate_presence_of(:other_info) }

  it { is_expected.not_to allow_value('asdf').for(:email) }

  it { is_expected.to have_many(:parcels) }
end
