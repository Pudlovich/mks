require 'spec_helper'

RSpec.describe Employee::ParcelsController do
  describe "GET #index" do
    before(:each) do
      FactoryGirl.create_list(:parcel, 3)
      FactoryGirl.create_list(:parcel, 3, :accepted)
      FactoryGirl.create_list(:parcel, 3, :rejected)
    end

    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user) }
      it "redirects to applicatioon root" do
        sign_in user
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }

      before(:each) do
        sign_in user
        get :index
      end

      it "populates @pending_parcels array with all pending parcels in the DB" do
        expect(assigns(:pending_parcels)).to match_array(Parcel.pending)
      end

      it "assigns the newest pending parcel first" do
        expect(assigns(:pending_parcels)[0]).to eq(Parcel.pending.last)
      end

      it "populates @accepted_parcels array with all accepted parcels in the DB" do
        expect(assigns(:accepted_parcels)).to match_array(Parcel.accepted)
      end

      it "assigns the newest accepted parcel first" do
        expect(assigns(:accepted_parcels)[0]).to eq(Parcel.accepted.last)
      end

      it "populates @rejected_parcels array with all rejected parcels in the DB" do
        expect(assigns(:rejected_parcels)).to match_array(Parcel.rejected)
      end

      it "assigns the newest rejected parcel first" do
        expect(assigns(:rejected_parcels)[0]).to eq(Parcel.rejected.last)
      end

      it "renders the :index view" do
        expect(response).to render_template :index
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      before(:each) do
        sign_in user
        get :index
      end

      it "populates @pending_parcels array with all pending parcels in the DB" do
        expect(assigns(:pending_parcels)).to match_array(Parcel.pending)
      end

      it "assigns the newest pending parcel first" do
        expect(assigns(:pending_parcels)[0]).to eq(Parcel.pending.last)
      end

      it "populates @accepted_parcels array with all accepted parcels in the DB" do
        expect(assigns(:accepted_parcels)).to match_array(Parcel.accepted)
      end

      it "assigns the newest accepted parcel first" do
        expect(assigns(:accepted_parcels)[0]).to eq(Parcel.accepted.last)
      end

      it "populates @rejected_parcels array with all rejected parcels in the DB" do
        expect(assigns(:rejected_parcels)).to match_array(Parcel.rejected)
      end

      it "assigns the newest rejected parcel first" do
        expect(assigns(:rejected_parcels)[0]).to eq(Parcel.rejected.last)
      end

      it "renders the :index view" do
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #edit" do
    let(:edited_parcel) { FactoryGirl.create(:parcel) }

    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user) }
      it "redirects to applicatioon root" do
        sign_in user
        get :edit, id: edited_parcel
        expect(response).to redirect_to root_path
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }

      before(:each) do
        sign_in user
        get :edit, id: edited_parcel
      end

      it "assigns the requested parcel to @parcel" do
        expect(assigns(:parcel)).to eq(edited_parcel)
      end

      it "renders the :edit view" do
        expect(response).to render_template :edit
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      before(:each) do
        sign_in user
        get :edit, id: edited_parcel
      end

      it "assigns the requested parcel to @parcel" do
        expect(assigns(:parcel)).to eq(edited_parcel)
      end

      it "renders the :edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  # describe "PUT #update" do

  # end
end
