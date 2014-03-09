class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    binding.pry
    @user = user
    mail from: 'noreply@myflix.com', to: user.email, subject: "Your new account!"
  end

  def send_password_reset_email(user)
    @user = user
    mail from: 'password_reset@myflix.com', to: user.email, subject: "Password reset"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail from: @invitation.inviter.full_name, to: @invitation.recipient_email, subject: "Invitation"
  end
end
