require 'spec_helper'

RSpec.describe Employee::ParcelsController do
  describe "GET #index" do
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

      it "populates @parcels array with all parcels in the DB" do
        expect(assigns(:parcels)).to match_array(Parcel.all)
      end

      it "assigns the newest parcel first" do
        expect(assigns(:parcels)[0]).to eq(Parcel.last)
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

      it "populates @parcels array with all parcels in the DB" do
        expect(assigns(:parcels)).to match_array(Parcel.all)
      end

      it "assigns the newest parcel first" do
        expect(assigns(:parcels)[0]).to eq(Parcel.last)
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
