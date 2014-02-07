class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    # binding.pry
    user = User.where(email: params[:email]).first
    # Watch out for nil condition for @user here
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, success: "You are signed in."
    else
      flash[:danger] = "There is something wrong with your username or password"
      redirect_to sign_in_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out"
    redirect_to root_path
  end
end
