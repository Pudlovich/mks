require 'spec_helper'
require 'support/controller_macros'

RSpec.describe ParcelsController do
  describe "GET #index" do
    context "user with parcels logged in" do
      login_user_with_parcel

      it "populates @parcels array with parcels belonging to the user" do
        get :index
        expect(assigns(:parcels)).to eq(User.last.parcels)
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end

    context "user without parcels logged in" do
      login_user

      it "leaves @parcels array empty" do
        get :index
        expect(assigns(:parcels)).to eq([])
      end

      it "renders the :index view" do
        get :index
        expect(response).to render_template :index
      end
    end

    context "user not logged in" do
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
    context "existing parcel" do
      parcel = FactoryGirl.create(:parcel)
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
      def valid_attributes
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
