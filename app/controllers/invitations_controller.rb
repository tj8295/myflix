class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitations_params.merge!(inviter: current_user))

    if @invitation.save
      AppMailer.send_invitation_email(@invitation).deliver
      flash[:success] = "You have sent an invitation."
      redirect_to new_invitation_path

    else
      flash[:danger] = "Invalid input, email not sent"
      render :new
    end

  end

  private
    def invitations_params
      params.require(:invitation).permit(:inviter_id, :recipient_name, :recipient_email, :message)
    end
end


