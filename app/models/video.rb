class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title_categorized(search_term)
    raw_results = self.search_by_title(search_term)

    raw_results.reduce(SearchResult.new) do |result, video|
      result.add_video(video)
      result
    end
  end

  private
    def self.search_by_title(search_term)
      return [] if search_term.blank?
      where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
    end
end
