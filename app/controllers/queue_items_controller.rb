class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items.sort_by(&:position)
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
