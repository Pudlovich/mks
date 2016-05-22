require 'spec_helper'

RSpec.describe Admin::UsersController do
  describe "GET #index" do
    before(:each) do
      FactoryGirl.create_list(:user, 3)
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
      it "redirects to applicatioon root" do
        sign_in user
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      before(:each) do
        sign_in user
        get :index
      end

      it "populates @users array with all users in the DB" do
        binding.pry
        expect(assigns(:users)).to match_array(User.all)
      end

      it "assigns the newest user first" do
        expect(assigns(:users)[0]).to eq(User.last)
      end

      it "renders the :index view" do
        expect(response).to render_template :index
      end
    end
  end

  describe "GET #edit" do
    # let(:edited_user) { FactoryGirl.create(:user) }
    # context "when user is a client" do
    #   let(:user) { FactoryGirl.create(:user) }
    #   it "redirects to applicatioon root" do
    #     sign_in user
    #     get :edit, id: edited_user.id
    #     expect(response).to redirect_to root_path
    #   end
    # end

    # context "when user is an employee" do
    #   let(:user) { FactoryGirl.create(:user, :employee) }
    #   it "redirects to applicatioon root" do
    #     sign_in user
    #     get :edit, id: edited_user.id
    #     expect(response).to redirect_to root_path
    #   end
    # end
  end

  describe "PUT #update" do
    
  end
end
