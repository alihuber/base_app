module BaseMailer
  class ApplicationMailer < ActionMailer::Base
    default from: Rails.configuration.sender_email
  end
end
