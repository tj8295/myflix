require 'spec_helper'

describe ForgotPasswordsController do
  before { ActionMailer::Base.deliveries.clear }

  describe "POST create" do
      context "with blank input" do
        it "redirects to the forgot password page" do
          post :create
          expect(response).to redirect_to forgot_password_path
        end

        it "should show an error message" do
          post :create
          expect(flash[:danger]).to include("Email field cannot be blank.")
        end
      end

      context "with email in the system" do
        it "redirects to password confirmation page on valid input" do
          joe = Fabricate(:user, email: "joe@example.com")
          post :create, email: "joe@example.com"
          expect(response).to redirect_to forgot_password_confirmation_path
        end

        # it "creates token" do
        #   joe = Fabricate(:user, email: "joe@example.com")
        #   post :create, email: "joe@example.com"
        #   expect(User.find_by(email: "joe@example.com").token).not_to be_nil
        # end

        it "sends email to user" do
          joe = Fabricate(:user, email: "joe@example.com")
          post :create, email: "joe@example.com"
          expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
        end
      end

      context "with non-exisiting email" do
        it "redirects to signin page" do
          joe = Fabricate(:user, email: "joe@example.com")
          post :create, email: "jill@bademail.com"
          expect(response).to redirect_to forgot_password_path
        end
      end
  end # end describe post create

    describe "GET password_reset" do
      context "with valid token" do
        it "renders the password reset page" do
          # joe = Fabricate(:user, email: "joe@example.com")
          # post :create, email: "joe@example.com"
          # token = joe.reload.token
          # expect(response).to render :password_reset
        end
      end

      context "with invalid token"
    end
end
