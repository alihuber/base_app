module BaseAuth
  class User
    class ResetPassword < ActiveInteraction::Base
      string    :token,    default: nil
      string    :password, default: nil
      validates :password, presence: true,
                           length: { minimum: 6, allow_blank: true }

      def execute
        return errors.add(:token, "error") unless token
        user = User.find_by_password_reset_token(token)
        return errors.add(:token, "error") unless user
        # reset attempt has to be within 2 weeks since reset request,
        # otherwise: new request
        if user.password_reset_sent_at < 2.weeks.ago
          return errors.add(:token, "error")
        end

        user.password               = password
        user.password_reset_sent_at = nil
        user.password_reset_token   = nil
        user.save!
      end
    end
  end
end
