require 'rails_helper'

RSpec.describe Operation, type: :model do
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:parcel) }
  it { is_expected.not_to validate_presence_of(:place) }
  it { is_expected.not_to validate_presence_of(:additional_info) }

  it { is_expected.to belong_to(:parcel) }
  it { is_expected.to belong_to(:user) }

  it { should define_enum_for(:kind) }
end
