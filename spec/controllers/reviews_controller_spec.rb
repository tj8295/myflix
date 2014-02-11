require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }
    context "user authenticated" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid input" do
        before do
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end
        it "redirects to the video show page" do
          expect(response).to redirect_to video
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end

        it "creates a review associated with the video" do
          expect(Review.first.video).to eq(video)
        end

        it "creates a review associated with the signed in user" do
          expect(Review.first.user).to eq(current_user)
        end

        it "sets the flash[:success]" do
          expect(flash[:success]).not_to be_nil
        end

      end

      context "with invalid input" do
        it "does not create a @review in db" do
          post :create, review: { content: "", rating: 0 }, video_id: video.id
          expect(Review.count).to eq(0)
        end
        it "sets the flash[:danger]" do
          post :create, review: { content: "", rating: 0 }, video_id: video.id
          expect(flash[:danger]).not_to be_nil
        end

        it "renders the video/show template" do
          post :create, review: { content: "", rating: 0 }, video_id: video.id
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do
          post :create, review: { content: "", rating: 0 }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: { content: "", rating: 0 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end

    context "user not authenticated" do
      it "redirect to signin page" do
        review = Fabricate(:review, video: video)
        post :create, review: { content: "", rating: 0 }, video_id: video.id
        expect(response).to redirect_to sign_in_path
      end

      it "sets the flash[:danger]" do
        review = Fabricate(:review, video: video)
        post :create, review: { content: "", rating: 0 }, video_id: video.id
        expect(flash[:danger]).not_to be_nil
      end
    end
  end
end
