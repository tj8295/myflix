require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "redirects to home_path for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "user valid credentials" do
      it "sets the session variable if user authenticated" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home_path if user authenticated" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to home_path
      end

      it "sets the notice" do
        user = Fabricate(:user)
        post :create, email: user.email, password: user.password
        expect(flash[:success]).not_to be_blank
      end
    end

    context "user unauthenticated" do
      before do
       user = Fabricate(:user)
       post :create, email: user.email, password: user.password + "ok"
      end

      it "does not set the session variable if user not authenticated" do
       expect(session[:user_id]).to be_nil
      end

      it "redirects to sign_in_path if user not authenticated" do
       expect(response).to redirect_to sign_in_path
      end

      it "sets the :danger message" do
       expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end
    it "sets the session to nil" do
      expect(session[:user_id]).to be_nil
    end

    it "sets the flash[:success] message" do
      expect(flash[:success]).not_to be_nil
    end

    it "redirects_to root_path" do
      expect(response).to redirect_to root_path
    end
  end
end
