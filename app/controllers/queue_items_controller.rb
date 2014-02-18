class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def update_queue


    params[:queue_items].each do |queue_item_data|
      queue_item = QueueItem.find(queue_item_data[:id])
      queue_item.update_attributes(position: queue_item_data[:position])
    end

    current_user.queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end

    redirect_to my_queue_path


#     context "authenticated user" do
#       it "it redirects to my_queue page" do
#         alice = Fabricate(:user)
#         session[:user_id] = alice.id
#         queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
#         get :update, "queue_items" =>
#         {
#           "item_#{queue_item1.id}" => {"position"=> "2", "queue_item_id" => "#{queue_item1.id}", "rating" => "5"}
#         }
#         expect(response).to redirect_to my_queue_path
#       end

#       it "assigns a post of one item position one" do
#         alice = Fabricate(:user)
#         session[:user_id] = alice.id
#         queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
#         get :update, "queue_items" =>
#         {
#           "item_#{queue_item1.id}" => {"position"=> "2", "queue_item_id" => "#{queue_item1.id}", "rating" => "5"}
#         }
#         expect(QueueItem.first.position).to eq(1)
#       end

#       it "reorders items in the queue based on position for two items" do
#         alice = Fabricate(:user)
#         session[:user_id] = alice.id
#         queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
#         queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

#         get :update, "queue_items" =>
#         {
#          "item_#{queue_item1.id}" => {"position"=> "2", "queue_item_id" => "#{queue_item1.id}", "rating" => "5" },
#          "item_#{queue_item2.id}" => {"position"=> "1", "queue_item_id" => "#{queue_item2.id}", "rating" => "5" }
#         }

#         expect(QueueItem.all.order(:position)).to eq([queue_item2, queue_item1])
#       end

#       it "sets position of items in sequential order starting from 1" do
#         alice = Fabricate(:user)
#         session[:user_id] = alice.id
#         queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
#         queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

#         get :update, "queue_items" =>
#         {
#          "item_#{queue_item1.id}" => {"position"=> "5", "queue_item_id" => "#{queue_item1.id}", "rating" => "5" },
#          "item_#{queue_item2.id}" => {"position"=> "6", "queue_item_id" => "#{queue_item2.id}", "rating" => "5" }
#         }
#         expect(QueueItem.all.map(&:position)).to eq([1, 2])
#       end

#       it "only accpets integer for position" do
#         # alice = Fabricate(:user)
#         # session[:user_id] = alice.id
#         # queue_item1 = Fabricate(:queue_item, user: alice, position: 1)
#         # queue_item2 = Fabricate(:queue_item, user: alice, position: 2)

#         # get :update, "queue_items" =>
#         # {
#         #  "item_#{queue_item1.id}" => {"position"=> "m", "queue_item_id" => "#{queue_item1.id}", "rating" => "5" }
#         # }
#         # expect(flash[:danger]).not_to be_nil
#       end
#     end
#     context "unauthenticated user"
#   end



  end

  def create
    video = Video.find(params[:video_id])
    queue_item = queue_video(video)
    if queue_item.save
      flash[:success] = "The video was added to queue."
      redirect_to my_queue_path
    else
      flash[:danger] = "The video cannot be added twice."
      redirect_to video
    end
  end

  def destroy
    queue_item = QueueItem.find(params[:id])

    if current_user == queue_item.user
       queue_item.destroy
       flash[:success] = "The video has been deleted from your queue"
    else
       flash[:danger] = "You can not do that."
    end

    redirect_to my_queue_path
  end

  private
    def queue_video(video)
       QueueItem.new(user: current_user, video: video, position: new_queue_item_position)
     # unless current_user_queued_video?(video)
    end

    def new_queue_item_position
      current_user.queue_items.count + 1
    end

    def current_user_queued_video?(video)
      current_user.queue_items.map(&:video).include?(video)
    end
end
