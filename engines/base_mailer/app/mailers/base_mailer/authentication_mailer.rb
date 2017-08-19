module BaseMailer
  class AuthenticationMailer < ApplicationMailer


    def request_password_reset(recipient, data)
      @reset_link = data.reset_link

      mail to: recipient,
           subject: t(".subject")
    end
  end
end
