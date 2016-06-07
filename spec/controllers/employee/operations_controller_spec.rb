require 'spec_helper'

RSpec.describe Employee::OperationsController do
  describe "GET #new" do
    before(:each) do 
      sign_in user
      get :new
    end

    context 'when user is a client' do
      let(:user) { FactoryGirl.create(:user) }

      it "redirects to applicatioon root" do
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is an employee' do
      let(:user) { FactoryGirl.create(:user, :employee) }

      it "assigns a new Operation to @operation" do
        expect(assigns(:operation)).to be_a_new(Operation)
      end

      it "renders the :new view" do
        expect(response).to render_template :new
      end
    end

    context 'when user is admin' do
      let(:user) { FactoryGirl.create(:user, :admin) }

      it "assigns a new Operation to @operation" do
        expect(assigns(:operation)).to be_a_new(Operation)
      end

      it "renders the :new view" do
        expect(response).to render_template :new
      end
    end
  end

  shared_examples 'valid create' do
    it "saves a new Operation in the DB" do
      expect{
        request
      }.to change(parcel.operations,:count).by(1)
    end

    it "saves an Operation of given kind" do
      request
      expect(Operation.last.kind).to eq(operation_attributes[:kind])
    end

    it "saves provided place in operation" do
      request
      expect(Operation.last.place).to eq(operation_attributes[:place])
    end

    it "assigns the correct parcel to the operation" do
      request
      expect(Operation.last.parcel).to eq(parcel)
    end

    it "redirects to the :new view" do
      request
      expect(response).to redirect_to new_employee_operation_path
    end
  end

  describe "POST #create" do
    before(:each) do 
      sign_in user
    end

    let (:request) { post :create, { operation: operation_attributes, parcel: { parcel_number: parcel.parcel_number } } }

    context 'when user is a client' do
      let(:user) { FactoryGirl.create(:user) }
      let(:parcel) { FactoryGirl.create(:parcel) }
      let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up, :with_place) }

      it "redirects to applicatioon root" do
        request
        expect(response).to redirect_to root_path
      end
    end

    context 'when user is an employee' do
      let(:user) { FactoryGirl.create(:user, :employee) }

      context 'with valid attributes' do
        let(:parcel) { FactoryGirl.create(:parcel) }
        let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up, :with_place) }

        include_examples 'valid create'

        context 'with additional_info' do
          let(:parcel) { FactoryGirl.create(:parcel) }
          let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up, :with_place, :with_additional_info) }

          include_examples 'valid create'

          it "saves provided additional info in operation" do
            request
            expect(Operation.last.additional_info).to eq(operation_attributes[:additional_info])
          end
        end
      end

      context 'no place given' do
        let(:parcel) { FactoryGirl.create(:parcel) }
        let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up) }

        it "doesn't save a new Operation in the DB" do
          expect{
            request
          }.to change(parcel.operations,:count).by(0)
        end

        it "renders the :new view" do
          request
          expect(response).to render_template :new
        end
      end

      context 'invalid parcel' do
        let(:parcel) { FactoryGirl.build(:parcel) }
        let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up) }

        it "doesn't save a new Operation in the DB" do
          expect{
            request
          }.to change(parcel.operations,:count).by(0)
        end

        it "renders the :new view" do
          request
          expect(response).to render_template :new
        end
      end
    end

    context 'when user is admin' do
      let(:user) { FactoryGirl.create(:user, :admin) }

      context 'with valid attributes' do
        let(:parcel) { FactoryGirl.create(:parcel) }
        let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up, :with_place) }

        include_examples 'valid create'

        context 'with additional_info' do
          let(:parcel) { FactoryGirl.create(:parcel) }
          let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up, :with_place, :with_additional_info) }

          include_examples 'valid create'

          it "saves provided additional info in operation" do
            request
            expect(Operation.last.additional_info).to eq(operation_attributes[:additional_info])
          end
        end
      end

      context 'no place given' do
        let(:parcel) { FactoryGirl.create(:parcel) }
        let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up) }

        it "doesn't save a new Operation in the DB" do
          expect{
            request
          }.to change(parcel.operations,:count).by(0)
        end

        it "renders the :new view" do
          request
          expect(response).to render_template :new
        end
      end

      context 'invalid parcel' do
        let(:parcel) { FactoryGirl.build(:parcel) }
        let(:operation_attributes) { FactoryGirl.attributes_for(:operation, :parcel_picked_up) }

        it "doesn't save a new Operation in the DB" do
          expect{
            request
          }.to change(parcel.operations,:count).by(0)
        end

        it "renders the :new view" do
          request
          expect(response).to render_template :new
        end
      end
    end
  end
end
