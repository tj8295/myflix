class SearchResult
  def initialize
    @data = {}
  end

  def add_video(video)
    current_videos_in_category = @data[video.category] || []
    @data[video.category] = current_videos_in_category << video
  end

  def categories
    @data.keys
  end

  def videos_for_category(category)
    @data[category]
  end
end
