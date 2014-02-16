require 'spec_helper'

describe MyQueueController do
  describe "POST update" do
    context "authenticated user" do
      it "it redirects to my_queue page" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        get :update, "queue_items" =>
        {
          "item_#{queue_item1.id}" => {"position"=> "2", "queue_item_id" => "#{queue_item1.id}", "rating" => "5"}
        }
        expect(response).to redirect_to my_queue_path
      end

      it "assigns a post of one item position one" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        get :update, "queue_items" =>
        {
          "item_#{queue_item1.id}" => {"position"=> "2", "queue_item_id" => "#{queue_item1.id}", "rating" => "5"}
        }
        expect(QueueItem.first.position).to eq(1)
      end

      it "reorders items in the queue based on position for two items" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

        get :update, "queue_items" =>
        {
         "item_#{queue_item1.id}" => {"position"=> "2", "queue_item_id" => "#{queue_item1.id}", "rating" => "5" },
         "item_#{queue_item2.id}" => {"position"=> "1", "queue_item_id" => "#{queue_item2.id}", "rating" => "5" }
        }

        expect(QueueItem.all.order(:position)).to eq([queue_item2, queue_item1])
      end

      it "sets position of items in sequential order starting from 1" do
        alice = Fabricate(:user)
        session[:user_id] = alice.id
        queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

        get :update, "queue_items" =>
        {
         "item_#{queue_item1.id}" => {"position"=> "5", "queue_item_id" => "#{queue_item1.id}", "rating" => "5" },
         "item_#{queue_item2.id}" => {"position"=> "6", "queue_item_id" => "#{queue_item2.id}", "rating" => "5" }
        }
        expect(QueueItem.all.map(&:position)).to eq([1, 2])
      end

      it "only accpets integer for position" do
        # alice = Fabricate(:user)
        # session[:user_id] = alice.id
        # queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
        # queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

        # get :update, "queue_items" =>
        # {
        #  "item_#{queue_item1.id}" => {"position"=> "m", "queue_item_id" => "#{queue_item1.id}", "rating" => "5" }
        # }
        # expect(flash[:danger]).not_to be_nil
      end
    end
    context "unauthenticated user"
  end
end

# params { queue_item_1 { position: 2, video_id: 5, rating: 5 } }
