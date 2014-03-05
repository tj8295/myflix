class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = params[:id]
    else
      flash[:danger] = "This is not a valid reset"
      redirect_to expired_token_path
    end
  end

  def expired_token; end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.password = params[:password]
      flash[:success] = "Password updated"
      user.generate_token
      user.save
      redirect_to sign_in_path
    else
      flash[:danger] = "This token is not valid."
      redirect_to expired_token_path
    end
  end
end

