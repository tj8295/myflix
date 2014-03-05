require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    context "with valid token" do
      it "displays the reset password page" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        get :show, id: "12345"
        expect(response).to render_template :show
      end

      it "sets @token instance variable" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        get :show, id: "12345"
        expect(assigns(:token)).to eq("12345")
      end
    end

    context "with invalid token" do
      it "redirects user to expired token page" do
        get :show, id: "12345"
        expect(response).to redirect_to expired_token_path
      end

      it "gives error message" do
        joe = Fabricate(:user, email: "joe@example.com")
        get :show, id: 'dsf'
        expect(flash[:danger]).to eq("This is not a valid reset")
      end
    end

    context "with no token" do
      it "redirects to expired token page" do
        joe = Fabricate(:user, email: "joe@example.com")
        get :show, id: ''
        expect(response).to redirect_to expired_token_path
      end
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "updates the users password" do
        joe = Fabricate(:user, password: "old_password")
        joe.update_column(:token, '12345')

        post :create, password: 'new_password', token: "12345"
        expect(joe.reload.authenticate('new_password')).not_to eq(true)
      end

      it "redirects to sign in page" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        post :create, password: 'fsdsdf', token: "12345"
        expect(response).to redirect_to sign_in_path
      end

      it "sets flash success message" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        post :create, password: 'fsdsdf', token: "12345"
        expect(flash[:success]).to be_present
      end

      it "regenerates users token" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        post :create, password: 'fsdsdf', token: '12345'
        expect(User.find(joe.id).token).not_to eq('12345')
      end
    end

    context "with invalid token" do
      it "redirects to expired token" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        post :create, password: 'fsdsdf', token: "mfdsndfsa"
        expect(response).to redirect_to expired_token_path
      end

      it "sets flash danger message" do
        joe = Fabricate(:user)
        joe.update_column(:token, '12345')
        post :create, password: 'fsdsdf', token: "mfdsndfsa"
        expect(flash[:danger]).to be_present
      end
    end
  end
end
