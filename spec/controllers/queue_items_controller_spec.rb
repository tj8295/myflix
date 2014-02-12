require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "user authenticated" do
      it "returns @queue_items as array for current_user" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice)
        queue_item2 = Fabricate(:queue_item, user: alice)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end
    end

    context "user not authenticated" do
      it "redirects to the signin page" do
        alice = Fabricate(:user)
        queue_item1 = Fabricate(:queue_item, user: alice)
        queue_item2 = Fabricate(:queue_item, user: alice)
        get :index
        expect(response).to redirect_to sign_in_path
      end
    end
  end

  describe "POST create" do
    context "user authenticated" do
      context "video is not queue_items for current_user" do
        it "creates a queue_item" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          session[:user_id] = alice.id
          post :create, user_id: alice.id, id: friends.id
          expect(QueueItem.count).to eq(1)
        end

        it "sets the flash[:success] message" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          session[:user_id] = alice.id
          post :create, user_id: alice.id, id: friends.id
          expect(flash[:success]).not_to be_nil
        end

        it "redirects to my_queue" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          session[:user_id] = alice.id
          post :create, user_id: alice.id, id: friends.id
          expect(response).to redirect_to my_queue_path
        end
      end

      context "video is already in queue_items for current user" do
        it "does not create queue_item" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          queue_item = Fabricate(:queue_item, user: alice, video: friends)
          session[:user_id] = alice.id
          post :create, user_id: alice.id, id: friends.id
          expect(QueueItem.count).to eq(1)
        end

        it "sets the flash[:danger] message" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          queue_item = Fabricate(:queue_item, user: alice, video: friends)
          session[:user_id] = alice.id
          post :create, user_id: alice.id, id: friends.id
          expect(flash[:danger]).not_to be_nil
        end

        it "redirects user to video page" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          queue_item = Fabricate(:queue_item, user: alice, video: friends)
          session[:user_id] = alice.id
          post :create, user_id: alice.id, id: friends.id
          expect(response).to redirect_to friends
        end
      end

    end
    context "user not authenticated"
  end
end

