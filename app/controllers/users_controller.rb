class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = "User saved"
      redirect_to home_path
    else
      render :new
    end
  end

  def show
    @queue_items = current_user.queue_items
    @reviews = Review.where(user: current_user)
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end
end
