require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:parcels) }
  it { should define_enum_for(:role) }
end
