require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    it "sets @video to new video" do
      joe = Fabricate(:admin)
      set_current_user(joe)
      get :new
      expect(assigns(:video)).to be_instance_of Video
      expect(assigns(:video)).to be_new_record
    end

    it "redirects to home if user is not admin" do
      set_current_user
      get :new
      expect(response).to redirect_to home_path
    end

    it "sets flash[:danger] if user not admin" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end

  end
end

