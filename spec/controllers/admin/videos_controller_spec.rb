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

    it_behaves_like "requires admin" do
      let(:action) { get :new }
    end

    it "sets flash[:danger] if user not admin" do
      set_current_user
      get :new
      expect(flash[:danger]).to be_present
    end
  end

  describe "POST create" do
    it_behaves_like "require_sign_in" do
      let(:action) { post :create }
    end

    it_behaves_like "requires admin" do
      let(:action) { post :create }
    end


    context "with valid inputs" do
      it "redirects to add video controller page" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)
        expect(response).to redirect_to new_admin_video_path
      end

      it "creates video record" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)
        expect(Video.count).to eq(1)
      end

      it "uploads to amazon s3" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)

      end
      it "sets flash[:success] message" do
        set_current_admin
        post :create, video: Fabricate.attributes_for(:video)
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid inputs" do
      it "does not create a new video" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, description: "good show!" }
        expect(category.videos.count).to eq(0)
      end
      it "renders :new tempalte" do
        set_current_admin
        post :create, video: { title: "Monk" }
        expect(response).to render_template :new
      end

      it "sets flash[:danger] message" do
        set_current_admin
        post :create, video: { title: "Monk" }
        expect(flash[:danger]).to be_present
      end

      it "sets the @video variable" do
        set_current_admin
        category = Fabricate(:category)
        post :create, video: { category_id: category.id, title: "Monk", description: "good show!" }
        expect(assigns(:video)).to be_present
      end
    end
  end
end

