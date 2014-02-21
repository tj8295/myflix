class QueueItem < ActiveRecord::Base

  validates :position, numericality: { only_integer: true }
  belongs_to :user
  belongs_to :video

  validates_uniqueness_of :video_id, scope: [:user_id]
  validates_numericality_of :position, { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  def rating
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  def category_name
    category.name if video.category
  end

  private
    def review
     @review ||= Review.where(user_id: user.id, video_id: video.id).first
    end
end
