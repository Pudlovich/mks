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
    context 'when parcel wasnt accepted or rejected' do
      let (:parcel)  { FactoryGirl.create(:parcel) }

      it 'parcel is included in pending scope' do
        expect(Parcel.pending).to include(parcel)
      end

      it 'parcel is not included in accepted scope' do
        expect(Parcel.accepted).not_to include(parcel)
      end

      it 'parcel is not included in rejected scope' do
        expect(Parcel.rejected).not_to include(parcel)
      end

      it 'pending? method returns true' do
        expect(parcel.pending?).to be true
      end

      it 'rejected? method returns false' do
        expect(parcel.rejected?).to be false
      end

      it 'accepted? method returns false' do
        expect(parcel.accepted?).to be false
      end

      it 'parcel can be accepted' do
        parcel.accept!
        expect(parcel.accepted?).to be true
      end

      it 'parcel can be rejected' do
        parcel.reject!
        expect(parcel.rejected?).to be true
      end
    end

    context 'when parcel was rejected' do
      let (:parcel)  { FactoryGirl.create(:parcel, :rejected) }
      
      it 'parcel is not included in pending scope' do
        expect(Parcel.pending).not_to include(parcel)
      end

      it 'parcel is not included in accepted scope' do
        expect(Parcel.accepted).not_to include(parcel)
      end

      it 'parcel is included in rejected scope' do
        expect(Parcel.rejected).to include(parcel)
      end

      it 'pending? method returns false' do
        expect(parcel.pending?).to be false
      end

      it 'rejected? method returns true' do
        expect(parcel.rejected?).to be true
      end

      it 'accepted? method returns false' do
        expect(parcel.accepted?).to be false
      end

      it 'parcel can be accepted' do
        parcel.accept!
        expect(parcel.accepted?).to be true
      end
    end

    context 'when parcel was accepted' do
      let (:parcel)  { FactoryGirl.create(:parcel, :accepted) }
      
      it 'parcel is not included in pending scope' do
        expect(Parcel.pending).not_to include(parcel)
      end

      it 'parcel is included in accepted scope' do
        expect(Parcel.accepted).to include(parcel)
      end

      it 'parcel is not included in rejected scope' do
        expect(Parcel.rejected).not_to include(parcel)
      end

      it 'pending? method returns false' do
        expect(parcel.pending?).to be false
      end

      it 'rejected? method returns false' do
        expect(parcel.rejected?).to be false
      end

      it 'accepted? method returns true' do
        expect(parcel.accepted?).to be true
      end

      it 'parcel can be rejected' do
        parcel.reject!
        expect(parcel.rejected?).to be true
      end
    end
  end
end
