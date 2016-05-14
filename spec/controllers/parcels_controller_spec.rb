require 'spec_helper'

RSpec.describe ParcelsController do
  describe "GET #index" do
    context "when user with parcels is logged in" do
      let(:user) { FactoryGirl.create(:user, :with_parcels) }
      before(:each) do
        sign_in user
      end

      it "populates @parcels array with parcels belonging to the user" do
        get :index
        expect(assigns(:parcels)).to match_array(user.parcels)
      end

      it "assigns the newest parcel first" do
        get :index
        expect(assigns(:parcels)[0]).to eq(user.parcels.last)
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end

    context "when a user without parcels is logged in" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_in user
      end

      it "leaves @parcels array empty" do
        get :index
        expect(assigns(:parcels)).to eq([])
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end

    context "when a user is not logged in" do
      it "doesn't create the parcels array" do
        get :index
        expect(assigns(:parcels)).to eq(nil)
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #show" do
    context "when a parcel exists" do
      let(:parcel) { FactoryGirl.create(:parcel) }
      it "assigns a parcel with the given parcel_number to @parcel" do
        get :show, parcel_number: parcel.parcel_number
        expect(assigns(:parcel)).to eq(parcel)
      end

      it "renders the :show view" do
        get :show, parcel_number: parcel.parcel_number
        expect(response).to render_template :show
      end
    end

    it "redirects to :index when a parcel doesn't exist" do
      get :show, parcel_number: 2
      expect(response).to redirect_to :action => :index
    end
  end

  describe "GET #new" do
    it "assigns a new Parcel to @parcel" do
      get :new
      expect(assigns(:parcel)).to be_a_new(Parcel)
    end

    it "assigns blank SenderInfo and RecipientInfo to @parcel" do
      get :new
      expect(assigns(:parcel).sender_info).to be_a_new(SenderInfo)
      expect(assigns(:parcel).recipient_info).to be_a_new(RecipientInfo)
    end

    it "renders the :new view" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) do
        sender_info_attributes = FactoryGirl.attributes_for(:sender_info)
        recipient_info_attributes = FactoryGirl.attributes_for(:recipient_info)
        FactoryGirl.attributes_for(:parcel).merge({sender_info_attributes: sender_info_attributes, recipient_info_attributes: recipient_info_attributes})
      end

      it "saves the new parcel in the database" do
        expect{
          post :create, parcel: valid_attributes
        }.to change(Parcel,:count).by(1)
      end

      it "redirects to the :show view" do
        post :create, parcel: valid_attributes
        expect(response).to redirect_to parcel_path(parcel_number: Parcel.last.parcel_number)
      end

      context "when a user is logged in" do
        let(:user) { FactoryGirl.create(:user) }
        before(:each) do
          sign_in user
        end

        it "redirects to the :show view" do
          post :create, parcel: valid_attributes
          expect(response).to redirect_to parcel_path(parcel_number: Parcel.last.parcel_number)
        end

        it "assigns the parcel to user" do
          expect{
            post :create, parcel: valid_attributes
          }.to change(user.parcels,:count).by(1)
        end
      end
    end

    context "with invalid attributes" do
      it "doesn't save the parcel in the database" do
        expect{
          post :create, parcel: FactoryGirl.attributes_for(:parcel, :invalid)
        }.to_not change(Parcel,:count)
      end

      it "renders the :new view" do
        post :create, parcel: FactoryGirl.attributes_for(:parcel, :invalid)
        expect(response).to render_template :new
      end
    end
  end
end
