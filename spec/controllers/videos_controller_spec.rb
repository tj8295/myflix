require 'spec_helper' # loads rails environment

describe VideosController do
  describe "GET show" do
    it "sets the @video variable for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects to the signin path for unauthenticated users" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe "POST search" do
    it "sets @results variabe for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video1 = Fabricate(:video, title: 'Futurama')
      post :search, search_term: 'rama'
      expect(assigns(:results).data).to eq({video1.category => [video1]})
    end

    it "redirects to signin page for unauthenticated users" do
      video1 = Fabricate(:video, title: 'Futurama')
      post :search, search_term: 'rama'
      expect(response).to redirect_to sign_in_path
    end
  end
end
