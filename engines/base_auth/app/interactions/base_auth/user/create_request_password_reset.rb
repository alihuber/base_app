module BaseAuth
  class User
    class CreateRequestPasswordReset < ActiveInteraction::Base
      include Engine.routes.url_helpers

      string    :email, default: nil
      validates :email, presence: true

      def execute
        user = User.find_by_email(email)
        if user
          generate_token(user, :password_reset_token)
          user.password_reset_sent_at = Time.zone.now
          user.save!
          BaseMailer.deliver("authentication/request_password_reset",
                             user.email,
                             reset_link: reset_url(user))
        else
          errors.add(:email,
                     I18n.t("base_auth.user.password_reset.new.failure"))
        end
      end


      private
      def reset_url(user)
        # mailer host has to be set in all environments,
        # dummy app is localhost:3000
        do_password_reset_url(
          user.password_reset_token,
          host: Rails.configuration.mailer_host
        )
      end

      def generate_token(record, column)
        begin
          record[column] = SecureRandom.urlsafe_base64(24)
        end while record.class.exists?(column => record[column])
      end
    end
  end
end
