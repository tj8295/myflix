class VideosController < ApplicationController
  before_action :require_user

  def index
    @categories = Category.all
  end

  def show
    # binding.pry
    @video = VideoDecorator.decorate(Video.find(params[:id]))
    @video = Video.find(params[:id])
    @reviews = @video.reviews
  end

  def search
    @results = Video.search_by_title_categorized(params[:search_term])
  end
end

