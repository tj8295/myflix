class AppMailer < ActionMailer::Base
  def new_registration(user)
    @user = user
    mail from: 'noreply@myflix.com', to: user.email, subject: "Your new account!"
  end
end
