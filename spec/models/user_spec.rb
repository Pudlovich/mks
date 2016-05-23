require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_many(:parcels) }
  it { should define_enum_for(:role) }

  describe 'roles' do
    let(:user)  { FactoryGirl.create(:user) }

    it 'client role is assigned by default' do
      expect(user.client?).to be true
      expect(user.employee?).to be false
      expect(user.admin?).to be false
    end

    it 'employee role is assigned through value 1' do
      user.update(role: 1)
      expect(user.client?).to be false
      expect(user.employee?).to be true
      expect(user.admin?).to be false
    end

    it 'admin role is assigned through value 2' do
      user.update(role: 2)
      expect(user.client?).to be false
      expect(user.employee?).to be false
      expect(user.admin?).to be true
    end
  end
end
