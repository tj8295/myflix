class MyQueueController < ApplicationController

  def update
    queue_items = params[:queue_items]
    queue_items.each do |key, value|
      queue_item = QueueItem.find(value[:queue_item_id])
      queue_item.update(position: value[:position], rating: value[:rating])
    end

    items_by_position = QueueItem.all.where(user: current_user).order(:position)
    items_by_position.each do |item|
      item.update!(position: items_by_position.index(item) + 1)
    end

    redirect_to my_queue_path
  end

end
