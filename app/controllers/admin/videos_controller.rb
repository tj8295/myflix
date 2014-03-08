class Admin::VideosController < AdminsController
  before_filter :require_user
  before_filter :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)
    if @video.save

    # current_user = video_params[:large_cover_url]
    # current_user.save
      flash[:success] = "Video saved #{@video.title}"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Video not saved"
      render :new
    end
  end

  private

  def require_admin
    unless current_user.admin?
      flash[:danger] = "You do not have access to that area"
      redirect_to home_path
    end
  end

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover)
  end

end
