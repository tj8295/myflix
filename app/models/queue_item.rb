class QueueItem < ActiveRecord::Base

  # validates :position, numericality: { only_integer: true }
  belongs_to :user
  belongs_to :video



  validates_uniqueness_of :video, scope: [:user]
  validates_numericality_of :position, { only_integer: true }

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video


  def rating
      review = Review.where(user_id: user.id, video_id: video.id).first
      review.rating if review
  end

  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first

    review = Review.create(user_id: user.id, video_id: video.id, content: new_rating, rating: new_rating) if review.blank?


    review.update(rating: new_rating)
  end


  def category_name
      category.name if video.category
  end

  # def category
  #     video.category
  # end
end
