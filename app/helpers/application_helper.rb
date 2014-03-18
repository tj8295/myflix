module ApplicationHelper
  def add_or_remove_from_queue_button
    if !current_user.queued_video?(@video)
        link_to '+ My Queue', queue_items_path(video_id: @video.id), method: :post, class: 'a btn btn-default'
    else
        link_to '- My Queue', QueueItem.where(user: current_user, video: @video).first, method: :delete, class: 'a btn btn-default'
    end
  end

  def options_for_video_reviews(selected=nil)
    options_for_select((1..5).map { |num| [pluralize(num, "star") , num]}, selected)
  end
end
