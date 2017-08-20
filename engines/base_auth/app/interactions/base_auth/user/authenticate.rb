module BaseAuth
  class User
    class Authenticate < ActiveInteraction::Base
      object :user,     default: nil, class: User
      string :email,    default: nil
      string :password, default: nil

      validates :email, :password, presence: true

      def execute
        JsonWebToken.instance.encode(user_id: user.id) if get_user
      end

      private
      def get_user
        @user = BaseAuth::User.find_by(email: @email)
        if @user && @user.authenticate(@password)
          true
        else
          errors.add(:user, "authentication failed")
        end
      end
    end
  end
end
