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
    let(:edited_user) { FactoryGirl.create(:user) }

    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user) }
      it "redirects to applicatioon root" do
        sign_in user
        get :edit, id: edited_user
        expect(response).to redirect_to root_path
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }
      it "redirects to applicatioon root" do
        sign_in user
        get :edit, id: edited_user
        expect(response).to redirect_to root_path
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      before(:each) do
        sign_in user
        get :edit, id: edited_user
      end

      it "assigns the requested user to @user" do
        expect(assigns(:user)).to eq(edited_user)
      end

      it "renders the :edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "PUT #update/:id" do
    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user, :employee) }
      let(:edited_user) { FactoryGirl.create(:user) }

      before(:each) do
        sign_in user
        put :update, id: edited_user.id, user: {role: 'employee'}
      end

      it "redirects to applicatioon root" do
        expect(response).to redirect_to root_path
      end

      it "doesn't change the user" do
        expect(edited_user.role).to eq('client')
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }
      let(:edited_user) { FactoryGirl.create(:user) }

      before(:each) do
        sign_in user
        put :update, id: edited_user.id, user: {role: 'employee'}
      end

      it "redirects to applicatioon root" do
        expect(response).to redirect_to root_path
      end

      it "doesn't change the user" do
        expect(edited_user.role).to eq('client')
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      before(:each) do
        sign_in user
      end

      context "when role is changed from client" do
        let(:edited_user) { FactoryGirl.create(:user) }

        context "when role is changed to employee" do
          before(:each) do
            put :update, id: edited_user.id, user: {role: 'employee'}
            edited_user.reload
          end

          it "redirects to index" do
            expect(response).to redirect_to action: "index"
          end

          it "updates the user" do
            expect(edited_user.role).to eq('employee')
          end
        end

        context "when role is changed to admin" do
          before(:each) do
            put :update, id: edited_user.id, user: {role: 'admin'}
            edited_user.reload
          end

          it "redirects to index" do
            expect(response).to redirect_to action: "index"
          end

          it "updates the user" do
            expect(edited_user.role).to eq('admin')
          end
        end
      end

      context "when role is changed from employee" do
        let(:edited_user) { FactoryGirl.create(:user, :employee) }

        context "when role is changed to client" do
          before(:each) do
            put :update, id: edited_user.id, user: {role: 'client'}
            edited_user.reload
          end

          it "redirects to index" do
            expect(response).to redirect_to action: "index"
          end

          it "updates the user" do
            expect(edited_user.role).to eq('client')
          end
        end

        context "when role is changed to admin" do
          before(:each) do
            put :update, id: edited_user.id, user: {role: 'admin'}
            edited_user.reload
          end

          it "redirects to index" do
            expect(response).to redirect_to action: "index"
          end

          it "updates the user" do
            expect(edited_user.role).to eq('admin')
          end
        end
      end

      context "when role is changed from admin" do
        let(:edited_user) { FactoryGirl.create(:user, :admin) }

        context "when role is changed to client" do
          before(:each) do
            put :update, id: edited_user.id, user: {role: 'client'}
            edited_user.reload
          end

          it "redirects to index" do
            expect(response).to redirect_to action: "index"
          end

          it "updates the user" do
            expect(edited_user.role).to eq('client')
          end
        end

        context "when role is changed to employee" do
          before(:each) do
            put :update, id: edited_user.id, user: {role: 'employee'}
            edited_user.reload
          end

          it "redirects to index" do
            expect(response).to redirect_to action: "index"
          end

          it "updates the user" do
            expect(edited_user.role).to eq('employee')
          end
        end
      end

      context "when admin tries to change his own role" do
        before(:each) do
          put :update, id: user.id, user: {role: 'employee'}
          user.reload
        end

        it "redirects to index" do
          expect(response).to redirect_to action: "index"
        end

        it "doesn't update the user" do
          expect(user.role).to eq('admin')
        end
      end
    end
  end
end
