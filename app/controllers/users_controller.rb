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
    if @user.save
      handle_invitation
      # Stripe.api_key = 'sk_test_S7SfOyW1ciRq6DBVsEb7WPRW'
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']

      Stripe::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => params[:stripeToken],
        :description => "Sign up charge for #{@user.email}."
      )

      flash[:success] = "Payment accepted. User saved"
      session[:user_id] = @user.id
      AppMailer.delay.send_welcome_email(@user)
      redirect_to home_path



    else

      #  rescue Stripe::CardError => e
      #   flash[:danger] = e.message
      #   redirect_to register_path
      # end

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

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      inviter = User.find(invitation.inviter_id)
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end

      # Relationship.create(follower: inviter, leader: @user)
      # Relationship.create(follower: @user, leader: inviter)
      # invitation.token = nil
      # invitation.save
      # inviter = User.find_inviter_by_token(params[:invitation_token])
      # Relationship.create_bilateral_relationship(inviter, @user)
  end

end
