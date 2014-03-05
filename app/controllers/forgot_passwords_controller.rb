class ForgotPasswordsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params[:email])
    if user
      AppMailer.send_password_reset_email(user).deliver
      flash[:success] = "Your email has been sent"
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Email field cannot be blank. " : "Email does not have an account"
      redirect_to forgot_password_path
    end
  end

  def reset_password

  end
end

