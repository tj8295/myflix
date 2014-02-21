require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "user authenticated" do
      it "returns @queue_items as array for current_user" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice)
        queue_item2 = Fabricate(:queue_item, user: alice)
        get :index
        expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
      end

      it "returns @queue_items in order of position" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 2)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 1)
        get :index
        expect(assigns(:queue_items)).to eq([queue_item2, queue_item1])
      end
    end

    context "user not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :index }
      end
    end
  end

  describe "POST update_queue" do

      it_behaves_like "require_sign_in" do
        let(:action) { post :update_queue, queue_items: [{ id: 1, position: 2 }] }
      end

    context "with valid inputs" do
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }
      let(:alice)       { Fabricate(:user) }

      before { set_current_user(alice) }

      it "redirects to the my queue page" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1  }]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1  }]
        expect(alice.queue_items).to eq([queue_item2, queue_item1])
      end

      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 1 }, { id: queue_item2.id, position: 1  }]
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do
      let(:queue_item1) { Fabricate(:queue_item, user: alice, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: alice, position: 2) }
      let(:alice)       { Fabricate(:user) }

      before { set_current_user(alice)}

      it "redirects to myqueue page" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 'a' }, { id: queue_item2.id, position: 1  }]
        expect(response).to redirect_to my_queue_path
      end

      it "sets flash[:danger] message" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 'a' }, { id: queue_item2.id, position: 1  }]
        expect(flash[:danger]).to eq("Invalid position numbers.")
      end

      it "does not update queue_items" do
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }, { id: queue_item2.id, position: 1.5  }]
        expect(queue_item1.reload.position).to eq(1)
        expect(queue_item2.reload.position).to eq(2)
      end
    end

    context "with queue items that do not belong to current user" do
      it "does not change the queue items" do
        set_current_user
        queue_item1 = Fabricate(:queue_item, position: 1)
        post :update_queue, queue_items: [{ id: queue_item1.id, position: 2 }]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end

  describe "POST create" do
    context "user authenticated" do
      context "video is not queue_items for current_user" do
        it "creates a queue_item" do
          set_current_user
          post :create, video_id: Fabricate(:video)
          expect(QueueItem.count).to eq(1)
        end

        it "creates a queue_item associated with signed in user" do
          alice = Fabricate(:user)
          set_current_user(alice)
          post :create, user_id: alice.id, video_id: Fabricate(:video)
          expect(QueueItem.first.user).to eq(alice)
        end

        it "creates a queue_item associated with the proper video" do
          friends = Fabricate(:video)
          set_current_user
          post :create, video_id: friends.id
          expect(QueueItem.first.video).to eq(friends)
        end

        it "puts the video as the last one in the queue" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          set_current_user(alice)
          queue_item = Fabricate(:queue_item, user: alice)
          post :create, video_id: friends
          friends_queue_item = QueueItem.where(video_id: friends .id, user_id: alice.id).first
          expect(friends_queue_item.position).to eq(2)
        end

        it "sets the flash[:success] message" do
          set_current_user
          post :create, video_id: Fabricate(:video)
          expect(flash[:success]).not_to be_nil
        end

        it "redirects to my_queue page" do
          set_current_user
          post :create, video_id: Fabricate(:video)
          expect(response).to redirect_to my_queue_path
        end
      end

      context "video is already in queue_items for current user" do
        it "does not create queue_item" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          queue_item = Fabricate(:queue_item, user: alice, video: friends)
          set_current_user(alice)
          post :create, video_id: friends.id
          expect(QueueItem.count).to eq(1)
        end

        it "sets the flash[:danger] message" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          queue_item = Fabricate(:queue_item, user: alice, video: friends)
          set_current_user(alice)
          post :create, video_id: friends.id
          expect(flash[:danger]).not_to be_nil
        end

        it "redirects user to video page" do
          alice = Fabricate(:user)
          friends = Fabricate(:video)
          queue_item = Fabricate(:queue_item, user: alice, video: friends)
          set_current_user(alice)
          post :create, video_id: friends.id
          expect(response).to redirect_to friends
        end
      end
    end

    context "user not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { post :create, user_id: 1, video_id: 1 }
      end
    end
  end

  describe "DELETE destroy" do
    context "user authenticated" do
      it "redirects to my queue path" do
        alice = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: alice)
        set_current_user(alice)
        get :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_path
      end

      it "deletes queue_item" do
        alice = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: alice)
        set_current_user(alice)
        get :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "sets the flash[:success]" do
        alice = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: alice)
        set_current_user(alice)
        get :destroy, id: queue_item.id
        expect(flash[:success]).not_to be_nil
      end

      it "does not delete queue_item for another user" do
        alice = Fabricate(:user)
        bob = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: alice)
        set_current_user(bob)
        get :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end

      it "normalizes the remaining queue items" do
        alice = Fabricate(:user)
        set_current_user(alice)
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)
        queue_item3 = Fabricate(:queue_item, user: alice, position: 3)
        post :destroy, id: queue_item2.id
        expect(alice.queue_items.map(&:position)).to eq([1, 2])
      end

    end

    context "user not authenticated" do
      it_behaves_like "require_sign_in" do
        let(:action) { get :destroy, id: 3 }
      end
    end
  end
end
