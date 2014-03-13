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
    context "with valid user input and valid card" do

      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end

      context "with and without invitation" do

        it "creates @user in db on valid input" do

          post :create, user: Fabricate.attributes_for(:user)
          expect(User.count).to eq(1)
        end

        it "redirects to home_path on valid input" do
          post :create, user: Fabricate.attributes_for(:user)
          expect(response).to redirect_to home_path
        end
      end

      context "with invitation" do
        it "creates following relationship so invitation recipient follows inviter" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter: alice)
          post :create, user: { email: invitation.recipient_email, password: "password", full_name: invitation.recipient_name }, invitation_token: invitation.token
          joe = User.find_by(email: invitation.recipient_email)
          expect(alice.follows?(joe)).to eq(true)
        end

        it "creates following relationship so inviter follows invitation recipient" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter: alice)
          post :create, user: { email: invitation.recipient_email, password: "password", full_name: invitation.recipient_name }, invitation_token: invitation.token
          joe = User.find_by(email: invitation.recipient_email)
          expect(joe.follows?(alice)).to eq(true)
        end

        it "resets invitation token" do
          alice = Fabricate(:user)
          invitation = Fabricate(:invitation, inviter: alice)
          post :create, user: { email: invitation.recipient_email, password: "password", full_name: invitation.recipient_name }, invitation_token: invitation.token
          expect(invitation.reload.token).to eq(nil)
        end
      end
    end

    context "email sending" do

      let(:charge) { double(:charge, successful?: true) }

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
        ActionMailer::Base.deliveries.clear
      end

      after { ActionMailer::Base.deliveries.clear }
      it "sends out an email to user with valid inputs" do
        post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends to the correct recipient" do
        attributes = Fabricate.attributes_for(:user)
        post :create, user: attributes
        message = ActionMailer::Base.deliveries.last
        message.to.should == [attributes[:email]]
      end

      it "has the correct content" do
        attributes = Fabricate.attributes_for(:user)
      post :create, user: {  email: "joe@example.com", password: "password", full_name: "Joe Smith"}
        message = ActionMailer::Base.deliveries.last
        message.body.should include("Joe Smith")
      end

    end

    context "valid personal info and decline card" do

      let(:charge) { double(:charge, successful?: false) }

      before do
        charge.stub(:error_message).and_return('Your charge was declined.')
        StripeWrapper::Charge.stub(:create).and_return(charge)

        post :create, user: Fabricate.attributes_for(:user), stripeToken: '1231241'
      end

      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "sets the flash error" do
        expect(flash[:danger]).to eq("Your charge was declined.")
      end
    end

    context "with invalid user input" do
      before do
        post :create, user: { email: " " }
        ActionMailer::Base.deliveries.clear
      end

      it "does not create @user in db on invalid input" do
        expect(User.count).to eq(0)
      end

      it "renders :new template on invalid input" do
        expect(response).to render_template :new
      end

      it "sets @user variable" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not send email with invalid inputs" do
        post :create, user: { full_name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not charge the credit card" do
        StripeWrapper::Charge.should_not_receive(:create)
        post :create, user: { email: "kevin@example.com" }
      end
    end
  end

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

