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

    it 'creates a operation with kind order_created' do
      expect(parcel.operations.size).to eq(1)
      expect(parcel.operations[0].order_created?).to be true
    end

    context 'when parcel has a sender' do
      let (:parcel_with_send)  { FactoryGirl.create(:parcel, :with_sender) }

      it 'assigns a user to order_created operation' do
        expect(parcel.operations[0].order_created?).to be true
        expect(parcel.operations[0].user).to eq(parcel.sender)
      end
    end
  end

  it { should define_enum_for(:status) }

  describe 'status -' do
    let(:parcel)  { FactoryGirl.create(:parcel) }

    it 'pending status is assigned by default' do
      expect(parcel.pending?).to be true
      expect(parcel.accepted?).to be false
      expect(parcel.rejected?).to be false
      expect(parcel.in_transit?).to be false
      expect(parcel.delivered?).to be false
    end

    it 'accepted status is assigned through value 1' do
      parcel.update(status: 1)
      expect(parcel.pending?).to be false
      expect(parcel.accepted?).to be true
      expect(parcel.rejected?).to be false
      expect(parcel.in_transit?).to be false
      expect(parcel.delivered?).to be false
    end

    it 'rejected status is assigned through value 2' do
      parcel.update(status: 2)
      expect(parcel.pending?).to be false
      expect(parcel.accepted?).to be false
      expect(parcel.rejected?).to be true
      expect(parcel.in_transit?).to be false
      expect(parcel.delivered?).to be false
    end

    it 'in_transit status is assigned through value 3' do
      parcel.update(status: 3)
      expect(parcel.pending?).to be false
      expect(parcel.accepted?).to be false
      expect(parcel.rejected?).to be false
      expect(parcel.in_transit?).to be true
      expect(parcel.delivered?).to be false
    end

    it 'rejected status is assigned through value 4' do
      parcel.update(status: 4)
      expect(parcel.pending?).to be false
      expect(parcel.accepted?).to be false
      expect(parcel.rejected?).to be false
      expect(parcel.in_transit?).to be false
      expect(parcel.delivered?).to be true
    end
  end
end
