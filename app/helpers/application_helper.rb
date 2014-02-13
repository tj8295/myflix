module ApplicationHelper
  def add_or_remove_from_queue_button
    if QueueItem.where(user: current_user, video: @video).first.blank?
        link_to '+ My Queue', queue_items_path(video_id: @video.id), method: :post, class: 'a btn btn-default'
    else
        link_to '- My Queue', queue_items_path(video_id: @video.id), method: :post, class: 'a btn btn-default'
    end
  end
end
