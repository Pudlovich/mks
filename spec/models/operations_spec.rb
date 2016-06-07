require 'rails_helper'

RSpec.describe Operation, type: :model do
  it { is_expected.to validate_presence_of(:kind) }
  it { is_expected.to validate_presence_of(:parcel) }
  it { is_expected.not_to validate_presence_of(:user) }
  it { is_expected.not_to validate_presence_of(:additional_info) }

  it { is_expected.to belong_to(:parcel) }
  it { is_expected.to belong_to(:user) }

  it { should define_enum_for(:kind) }

  describe 'place validations' do
    let(:parcel) { FactoryGirl.create(:parcel) }
    before(:each) do
      parcel
    end

    it 'allows creation of order_created operation without a place' do
      expect(parcel.operations.count).to eq(1)
      expect(parcel.operations.first.place).to be_blank
    end

    it 'allows creation of order_accepted operation without a place' do
      expect{
        FactoryGirl.create(:operation, :order_accepted, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end

    it 'allows creation of order_rejected operation without a place' do
      expect{
        FactoryGirl.create(:operation, :order_rejected, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end

    it 'doesnt allow creation of parcel_picked_up operation without a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_picked_up, parcel: parcel)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow creation of parcel_in_sorting_facility operation without a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_in_sorting_facility, parcel: parcel)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow creation of parcel_in_transit operation without a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_in_transit, parcel: parcel)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow creation of parcel_in_delivery operation without a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_in_delivery, parcel: parcel)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'doesnt allow creation of parcel_delivered operation without a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_delivered, parcel: parcel)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'allows creation of parcel_picked_up operation with a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_picked_up, :with_place, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end

    it 'allows creation of parcel_in_sorting_facility operation with a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_in_sorting_facility, :with_place, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end

    it 'allows creation of parcel_in_transit operation with a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_in_transit, :with_place, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end

    it 'allows creation of parcel_in_delivery operation with a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_in_delivery, :with_place, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end

    it 'allows creation of parcel_delivered operation with a place' do
      expect{
        FactoryGirl.create(:operation, :parcel_delivered, :with_place, parcel: parcel)
      }.to change(Operation,:count).by(1)
    end
  end
end
