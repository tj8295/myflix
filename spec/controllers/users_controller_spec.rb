require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "GET new_with_invitation_token" do
    context "with valid user input" do
      it "renders :new template" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(response).to render_template :new
      end

      it "sets @user with recipient_email" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:user).email).to eq(invitation.recipient_email)
      end

      it "sets @user with recipient_name" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:user).full_name).to eq(invitation.recipient_name)
      end

      it "sets @invitation" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:invitation_token)).to be_present
      end

      it "sets @invitation_token" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: invitation.token
        expect(assigns(:invitation_token)).to be_present
      end
    end

    context "with invalid user input" do
      it "redirects to expired_token page" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: 'dfsa'
        expect(response).to redirect_to expired_token_path
      end

      it "sets flash[:danger]" do
        invitation = Fabricate(:invitation)
        get :new_with_invitation_token, token: 'dfsa'
        expect(flash[:danger]).to be_present
      end

    end
  end

  describe "POST create" do
    context "successful user sign up" do
      it "redirects to home_path on valid input" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end
    end

    context "failed user sign up" do
      it "renders :new template" do
        result = double(:sign_up_result, successful?: false, error_message: "Error message")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { email: " " }
        expect(response).to render_template :new
      end

      it "sets the flash error" do
        result = double(:sign_up_result, successful?: false, error_message: "Error message.")
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: { email: " " }
        expect(flash[:danger]).to be_present
      end
    end
  end # end describe POST create

  describe "GET show" do
    it "sets the @user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      queue_item1 = Fabricate(:queue_item, user: alice)
      queue_item2 = Fabricate(:queue_item, user: alice)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :show, id: 3 }
    end
  end
end

