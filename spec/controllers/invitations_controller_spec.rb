require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to blank instance variable" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }

      it_behaves_like "require_sign_in" do
        let(:action) { post :create }
      end

    context "with valid inputs" do
      it "redirects to new invitation page on success" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: Fabricate.attributes_for(:invitation, user: alice )
        expect(response).to redirect_to new_invitation_path
      end

      it "creates invitation record" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { recipient_name: "Thomas", recipient_email: "joe@example.com", message: "Join this now" }
        expect(Invitation.count).to eq(1)
      end

      it "creates invitation record associated with current_user" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { recipient_name: "Thomas", recipient_email: "joe@example.com", message: "Join this now" }
        expect(alice.reload.invitations.count).to eq(1)
      end

      it "sends email to recipient" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { recipient_name: "Thomas", recipient_email: "joe@example.com", message: "Join this now" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sets flash[:success]" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { recipient_name: "Thomas", recipient_email: "joe@example.com", message: "Join this now" }
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not create invitation" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { message: "Join this now" }
        expect(Invitation.count).to eq(0)
      end

      it "does not send invitation" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { message: "Join this now" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets flash[:danger]" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { message: "Join this now" }
        expect(flash[:danger]).to eq("Invalid input, email not sent")
      end

      it "renders the :new template" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { message: "Join this now" }
        expect(response).to render_template :new
      end

      it "sets @invitation" do
        alice = Fabricate(:user)
        set_current_user(alice)
        post :create, invitation: { message: "Join this now" }
        expect(assigns(:invitation)).to be_present
      end
    end
  end
end
