class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items
  end

  def create
    video = Video.find(params[:video_id])
    queue_item = QueueItem.new(user: current_user, video: video)
    if queue_item.save
      flash[:success] = "The video was added to queue."
      redirect_to my_queue_path
    else
      flash[:danger] = "The video cannot be added twice."
      redirect_to video
    end
  end
end
