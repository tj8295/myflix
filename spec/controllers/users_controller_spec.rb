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

  # describe "#token_present?" do
  #   it "returns true if a hidden token is passed" do
  #     @controller = User.new

  #     post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Smith", token: 'sfdjio'}
  #     expect(create.send(:token_present?)).to eq(true)
  #   end
  # end

  describe "POST create" do
    before do
      charge = double('charge')
      charge.stub(:successful?).and_return(true)
      StripeWrapper::Charge.stub(:create).and_return(charge)
    end
    context "with valid user input" do
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
      before { ActionMailer::Base.deliveries.clear }
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

      it "does not send email with invalid inputs" do
        post :create, user: { full_name: "Joe Smith"}
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with invalid user input" do
      before do
        post :create, user: { email: " "}
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

