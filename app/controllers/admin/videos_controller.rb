class Admin::VideosController < AdminsController

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

    def video_params
      params.require(:video).permit(:title, :category_id, :description, :large_cover, :small_cover, :video_url)
    end
end
