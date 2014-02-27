class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail from: 'noreply@myflix.com', to: user.email, subject: "Your new account!"
  end
end
