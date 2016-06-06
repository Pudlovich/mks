require 'spec_helper'

RSpec.describe Employee::ParcelsController do
  describe "GET #index" do
    before(:each) do
      FactoryGirl.create_list(:parcel, 3)
      FactoryGirl.create_list(:parcel, 3, :accepted)
      FactoryGirl.create_list(:parcel, 3, :rejected)

      sign_in user
      get :index
    end

    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user) }
      it "redirects to applicatioon root" do
        expect(response).to redirect_to root_path
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }

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

    before(:each) do
      sign_in user
      get :edit, id: edited_parcel
    end

    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user) }
      it "redirects to applicatioon root" do
        expect(response).to redirect_to root_path
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }

      it "assigns the requested parcel to @parcel" do
        expect(assigns(:parcel)).to eq(edited_parcel)
      end

      it "renders the :edit view" do
        expect(response).to render_template :edit
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      it "assigns the requested parcel to @parcel" do
        expect(assigns(:parcel)).to eq(edited_parcel)
      end

      it "renders the :edit view" do
        expect(response).to render_template :edit
      end
    end
  end

  shared_examples 'valid update' do
    before(:each) do
      put :update, id: edited_parcel.id, parcel: { acceptance_status: acceptance_status, operation: { additional_info: additional_info } }
      edited_parcel.reload
    end

    it "redirects to index" do
      expect(response).to redirect_to action: "index"
    end

    it "updates the parcel" do
      expect(edited_parcel.acceptance_status).to eq(acceptance_status)
    end

    it "creates an operation" do
      expect(edited_parcel.operations.last.user).to eq(user)
    end

    context 'when additional_info is included' do
      let(:additional_info) { 'additional info' }
      it "redirects to index" do
        expect(response).to redirect_to action: "index"
      end

      it "updates the parcel" do
        expect(edited_parcel.acceptance_status).to eq(acceptance_status)
      end

      it "creates an operation" do
        expect(edited_parcel.operations.last.user).to eq(user)
      end

      it "includes additional_info in the operation" do
        expect(edited_parcel.operations.last.additional_info).to eq(additional_info)
      end
    end
  end

  shared_examples 'invalid update' do
    before(:each) do
      @old_acceptance = edited_parcel.acceptance_status
      put :update, id: edited_parcel.id, parcel: { acceptance_status: acceptance_status, operation: { additional_info: additional_info } }
      edited_parcel.reload
    end

    it "redirects to index" do
      expect(response).to redirect_to action: "index"
    end

    it "doesn't change the parcel status" do
      expect(edited_parcel.acceptance_status).to eq(@old_acceptance)
    end

    it "doesn't create an operation" do
      expect(edited_parcel.operations.last.user).not_to eq(user)
    end
  end

  describe "PUT #update" do
    before(:each) do
      sign_in user
    end

    let(:additional_info) { '' }

    context "when user is a client" do
      let(:user) { FactoryGirl.create(:user) }
      let(:edited_parcel) { FactoryGirl.create(:parcel) }

      before(:each) do
        put :update, id: edited_parcel.id, parcel: {acceptance_status: 'accepted'}
      end

      it "redirects to applicatioon root" do
        expect(response).to redirect_to root_path
      end

      it "doesn't change the user" do
        expect(edited_parcel.acceptance_status).to eq('pending')
      end
    end

    context "when user is an employee" do
      let(:user) { FactoryGirl.create(:user, :employee) }

      context "when parcel is pending" do
        let(:edited_parcel) { FactoryGirl.create(:parcel) }

        context "accepting the parcel" do
          let(:acceptance_status) { 'accepted' }

          include_examples 'valid update'         
        end

        context "rejecting the parcel" do
          let(:acceptance_status) { 'rejected' }

          include_examples 'valid update'
        end
      end

      context "when parcel is accepted" do
        let(:edited_parcel) { FactoryGirl.create(:parcel, :accepted) }

        context "accepting the parcel" do
          let(:acceptance_status) { 'accepted' }

          include_examples 'invalid update'
        end

        context "rejecting the parcel" do
          let(:acceptance_status) { 'rejected' }

          include_examples 'valid update'
        end
      end

      context "when parcel is rejected" do
        let(:edited_parcel) { FactoryGirl.create(:parcel, :rejected) }

        context "accepting the parcel" do
          let(:acceptance_status) { 'accepted' }

          include_examples 'valid update'
        end

        context "rejecting the parcel" do
          let(:acceptance_status) { 'rejected' }

          include_examples 'invalid update'
        end
      end
    end

    context "when user is admin" do
      let(:user) { FactoryGirl.create(:user, :admin) }

      context "when parcel is pending" do
        let(:edited_parcel) { FactoryGirl.create(:parcel) }

        context "accepting the parcel" do
          let(:acceptance_status) { 'accepted' }

          include_examples 'valid update'         
        end

        context "rejecting the parcel" do
          let(:acceptance_status) { 'rejected' }

          include_examples 'valid update'
        end
      end

      context "when parcel is accepted" do
        let(:edited_parcel) { FactoryGirl.create(:parcel, :accepted) }

        context "accepting the parcel" do
          let(:acceptance_status) { 'accepted' }

          include_examples 'invalid update'
        end

        context "rejecting the parcel" do
          let(:acceptance_status) { 'rejected' }

          include_examples 'valid update'
        end
      end

      context "when parcel is rejected" do
        let(:edited_parcel) { FactoryGirl.create(:parcel, :rejected) }

        context "accepting the parcel" do
          let(:acceptance_status) { 'accepted' }

          include_examples 'valid update'
        end

        context "rejecting the parcel" do
          let(:acceptance_status) { 'rejected' }

          include_examples 'invalid update'
        end
      end
    end
  end
end
