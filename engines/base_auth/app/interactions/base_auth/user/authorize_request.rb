module BaseAuth
  class User
    class AuthorizeRequest < ActiveInteraction::Base
      hash :headers do
        string :Authorization
      end
      validates :headers, presence: true

      def execute
        user
      end

      private
      def user
        @user ||= User.find(decoded_token[:user_id]) if decoded_token
        @user || errors.add(:token, "Invalid token") && nil
      end

      def decoded_token
        @decoded_token ||= JsonWebToken.instance.decode(token)
      end

      def token
        if headers["Authorization"].present?
          return headers["Authorization"].split(" ").last
        else
          errors.add(:token, "Missing token")
        end
        nil
      end
    end
  end
end
