require 'rails_helper'

RSpec.describe Parcel, type: :model do
  it { is_expected.to validate_presence_of(:width) }
  it { is_expected.to validate_presence_of(:height) }
  it { is_expected.to validate_presence_of(:depth) }
  it { is_expected.to validate_presence_of(:weight) }
  it { is_expected.not_to validate_presence_of(:name) }
  it { is_expected.not_to validate_presence_of(:sender) }
  it { is_expected.to validate_presence_of(:sender_info) }
  it { is_expected.to validate_presence_of(:recipient_info) }

  it { is_expected.to validate_numericality_of(:width) }
  it { is_expected.to validate_numericality_of(:height) }
  it { is_expected.to validate_numericality_of(:depth) }
  it { is_expected.to validate_numericality_of(:weight) }

  it { is_expected.not_to allow_value(0).for(:width)}
  it { is_expected.not_to allow_value(0).for(:height)}
  it { is_expected.not_to allow_value(0).for(:depth)}
  it { is_expected.not_to allow_value(0).for(:weight)}

  it { is_expected.to belong_to(:sender) }
  it { is_expected.to belong_to(:sender_info) }
  it { is_expected.to belong_to(:recipient_info) }
  it { is_expected.to have_many(:operations) }
  it { is_expected.to accept_nested_attributes_for(:recipient_info) }
  it { is_expected.to accept_nested_attributes_for(:sender_info) }

  describe 'object creation' do
    let (:parcel)  { FactoryGirl.create(:parcel) }
    
    it 'sets price when created' do
      expect(parcel.price).not_to be nil
      expect(parcel.price).to be > 0
    end

    it 'sets valid parcel_number when created' do
      expect(parcel.parcel_number).not_to be nil
      expect(Luhn.valid?(parcel.parcel_number)).to be true
    end
  end

  it { should define_enum_for(:acceptance_status) }

  describe 'acceptance status -' do
    let(:parcel)  { FactoryGirl.create(:parcel) }

    it 'pending status is assigned by default' do
      expect(parcel.pending?).to be true
      expect(parcel.accepted?).to be false
      expect(parcel.rejected?).to be false
    end

    it 'accepted status is assigned through value 1' do
      parcel.update(acceptance_status: 1)
      expect(parcel.pending?).to be false
      expect(parcel.accepted?).to be true
      expect(parcel.rejected?).to be false
    end

    it 'rejected status is assigned through value 2' do
      parcel.update(acceptance_status: 2)
      expect(parcel.pending?).to be false
      expect(parcel.accepted?).to be false
      expect(parcel.rejected?).to be true
    end
  end

  describe 'acceptance -' do
    let (:user) { FactoryGirl.create(:user, :employee) }

    context 'when parcel is pending' do
      let (:parcel)  { FactoryGirl.create(:parcel) }

      it 'parcel can be accepted' do
        parcel.accept!
        expect(parcel.accepted?).to be true
      end

      it 'parcel can be accepted by user' do
        parcel.accept!(user)
        expect(parcel.accepted?).to be true
        expect(parcel.operations.last.user).to eq(user)
      end

      it 'parcel can be rejected' do
        parcel.reject!
        expect(parcel.rejected?).to be true
      end

      it 'parcel can be rejected by user' do
        parcel.reject!(user)
        expect(parcel.rejected?).to be true
        expect(parcel.operations.last.user).to eq(user)
      end
    end

    context 'when parcel was rejected' do
      let (:parcel)  { FactoryGirl.create(:parcel, :rejected) }

      it 'parcel can be accepted' do
        parcel.accept!
        expect(parcel.accepted?).to be true
      end

      it 'parcel can be accepted by user' do
        parcel.accept!(user)
        expect(parcel.accepted?).to be true
        expect(parcel.operations.last.user).to eq(user)
      end
    end

    context 'when parcel was accepted' do
      let (:parcel)  { FactoryGirl.create(:parcel, :accepted) }

      it 'parcel can be rejected' do
        parcel.reject!
        expect(parcel.rejected?).to be true
      end

      it 'parcel can be rejected by user' do
        parcel.reject!(user)
        expect(parcel.rejected?).to be true
        expect(parcel.operations.last.user).to eq(user)
      end
    end
  end
end
