class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.new(review_params.merge!(user: current_user))

    if @review.save
      flash[:success] = "Review saved"
      redirect_to @video
    else
      flash[:danger] = "Review not saved. Incorrect input."
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private
    def review_params
      params.require(:review).permit(:rating, :content)
    end
end
