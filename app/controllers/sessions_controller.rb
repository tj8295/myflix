class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if user.active?
        session[:user_id] = user.id
        flash[:success] = "You are signed in."
        redirect_to home_path
      else
        flash[:danger] = "You account has been suspended, please contact customer service."
        redirect_to sign_in_path
      end
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
