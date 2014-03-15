class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def new_with_invitation_token
    @user = User.new
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user.email = invitation.recipient_email
      @user.full_name = invitation.recipient_name
      @invitation_token = invitation.token
      render :new
    else
      flash[:danger] = "Invalid token."
      redirect_to expired_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:stripeToken], params[:invitation_token])

    if result.successful?
      session[:user_id] = @user.id
      flash[:success] = "Thank you for registering with Myflix."
      redirect_to home_path
    else
      flash[:danger] = result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

private
  def user_params
    params.require(:user).permit(:email, :password, :full_name)
  end

  def token_present?
    !!params[:invitation_token]
  end


end
