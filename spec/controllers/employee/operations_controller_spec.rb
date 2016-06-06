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

  describe "POST #create" do
    before(:each) do 
      sign_in user
    end

    context 'when user is a client' do
      let(:user) { FactoryGirl.create(:user) }

      it "redirects to applicatioon root" do
        
      end
    end

    context 'when user is an employee' do
      let(:user) { FactoryGirl.create(:user, :employee) }

      context 'valid attributes' do
        it "saves a new Operation in the DB" do

        end

        it "assigns the correct parcel to the operation" do

        end

        it "redirects to the :new view" do
          
        end

        context 'with additional_info' do
          it "saves a new Operation in the DB" do

          end

          it "assigns the correct parcel to the operation" do

          end

          it "redirects to the :new view" do
            
          end
        end
      end

      context 'no place given' do
        it "doesn't save a new Operation in the DB" do

        end

        it "renders the :new view" do
          
        end
      end
    end

    # is it necessary?
    # context 'when user is admin' do
    #   let(:user) { FactoryGirl.create(:user, :admin) }

      
    # end
  end
end
