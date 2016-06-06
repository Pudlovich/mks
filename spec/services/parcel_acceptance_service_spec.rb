require 'rails_helper'

RSpec.shared_examples 'change of acceptance' do
  it 'returns true' do
    expect(ParcelAcceptanceService.new(parcel, acceptance_status, author).call).to be true
  end

  it 'changes the parcel status' do
    ParcelAcceptanceService.new(parcel, acceptance_status, author).call
    expect(parcel.acceptance_status).to eq(acceptance_status)
  end

  it 'creates an operation of requested kind' do
    ParcelAcceptanceService.new(parcel, acceptance_status, author).call
    expect(parcel.operations.last.kind).to eq(operation_kind)
  end
end

RSpec.shared_examples 'nothing changes' do
  it 'returns false' do
    expect(ParcelAcceptanceService.new(parcel, acceptance_status, author).call).to be false
  end

  it 'does not change the parcel status' do
    old_status = parcel.acceptance_status
    ParcelAcceptanceService.new(parcel, acceptance_status, author).call
    expect(parcel.acceptance_status).to eq(old_status)
  end

  it 'does not create an operation' do
    last_operation = parcel.operations.last
    ParcelAcceptanceService.new(parcel, acceptance_status, author).call
    expect(parcel.operations.last).to eq(last_operation)
  end
end

RSpec.describe ParcelAcceptanceService do
  describe 'accepting pending parcel' do
    let(:parcel) { FactoryGirl.create(:parcel) }
    let(:acceptance_status) { 'accepted' }
    let(:operation_kind) { 'order_accepted' }

    context 'without an author' do
      let(:author) { nil }
      include_examples 'change of acceptance'
    end

    context 'with an author' do
      let(:author) { FactoryGirl.create(:user) }
      include_examples 'change of acceptance'
      
      it 'sets the operation author correctly' do
        ParcelAcceptanceService.new(parcel, acceptance_status, author).call
        expect(parcel.operations.last.user).to eq(author)
      end
    end
  end

  describe 'rejecting pending parcel' do
    let(:parcel) { FactoryGirl.create(:parcel) }
    let(:acceptance_status) { 'rejected' }
    let(:operation_kind) { 'order_rejected' }

    context 'without an author' do
      let(:author) { nil }
      include_examples 'change of acceptance'
    end

    context 'with an author' do
      let(:author) { FactoryGirl.create(:user) }
      include_examples 'change of acceptance'
      
      it 'sets the operation author correctly' do
        ParcelAcceptanceService.new(parcel, acceptance_status, author).call
        expect(parcel.operations.last.user).to eq(author)
      end
    end
  end

  describe 'rejecting accepted parcel' do
    let(:parcel) { FactoryGirl.create(:parcel, :accepted) }
    let(:acceptance_status) { 'rejected' }
    let(:operation_kind) { 'order_rejected' }

    context 'without an author' do
      let(:author) { nil }
      include_examples 'change of acceptance'
    end

    context 'with an author' do
      let(:author) { FactoryGirl.create(:user) }
      include_examples 'change of acceptance'
      
      it 'sets the operation author correctly' do
        ParcelAcceptanceService.new(parcel, acceptance_status, author).call
        expect(parcel.operations.last.user).to eq(author)
      end
    end
  end

  describe 'accepting rejected parcel' do
    let(:parcel) { FactoryGirl.create(:parcel, :rejected) }
    let(:acceptance_status) { 'accepted' }
    let(:operation_kind) { 'order_accepted' }

    context 'without an author' do
      let(:author) { nil }
      include_examples 'change of acceptance'
    end

    context 'with an author' do
      let(:author) { FactoryGirl.create(:user) }
      include_examples 'change of acceptance'
      
      it 'sets the operation author correctly' do
        ParcelAcceptanceService.new(parcel, acceptance_status, author).call
        expect(parcel.operations.last.user).to eq(author)
      end
    end
  end

  describe 'accepting accepted parcel' do
    let(:parcel) { FactoryGirl.create(:parcel, :accepted) }
    let(:acceptance_status) { 'accepted' }
    let(:author) { nil }

    include_examples 'nothing changes'
  end

  describe 'rejecting rejected parcel' do
    let(:parcel) { FactoryGirl.create(:parcel, :rejected) }
    let(:acceptance_status) { 'rejected' }
    let(:author) { nil }

    include_examples 'nothing changes'
  end
end
