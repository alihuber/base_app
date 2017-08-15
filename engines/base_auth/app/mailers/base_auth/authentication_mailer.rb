class BaseAuth::AuthenticationMailer < ActionMailer::Base
  default from: "info@base-app.com"

  def request_password_reset(user, url)
    @user = user
    @url  = url
    mail(to: @user.email, subject: "Password reset")
  end
end
