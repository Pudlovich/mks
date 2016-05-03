require 'rails_helper'

RSpec.describe Parcel, type: :model do
  it { is_expected.to validate_presence_of(:width) }
  it { is_expected.to validate_presence_of(:height) }
  it { is_expected.to validate_presence_of(:depth) }
  it { is_expected.to validate_presence_of(:weight) }
  it { is_expected.not_to validate_presence_of(:name) }
  it { is_expected.not_to validate_presence_of(:sender_id) }

  it { is_expected.to validate_numericality_of(:width) }
  it { is_expected.to validate_numericality_of(:height) }
  it { is_expected.to validate_numericality_of(:depth) }
  it { is_expected.to validate_numericality_of(:weight) }

  it { is_expected.not_to allow_value(0).for(:width)}
  it { is_expected.not_to allow_value(0).for(:height)}
  it { is_expected.not_to allow_value(0).for(:depth)}
  it { is_expected.not_to allow_value(0).for(:weight)}

  it { is_expected.to belong_to(:sender) }

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
end
