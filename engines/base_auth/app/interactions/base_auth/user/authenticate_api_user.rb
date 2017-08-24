module BaseAuth
  class User
    class AuthenticateApiUser < ActiveInteraction::Base
      string :email,    default: nil
      string :password, default: nil

      validates :email, :password, presence: true

      def execute
        user = BaseAuth::User.find_by(email: @email)
        if user && user.authenticate(@password)
          JsonWebToken.instance.encode(user_id: user.id)
        else
          errors.add(:user, "authentication failed")
        end
      end
    end
  end
end
