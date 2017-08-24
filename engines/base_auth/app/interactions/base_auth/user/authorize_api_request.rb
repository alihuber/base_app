module BaseAuth
  class User
    class AuthorizeApiRequest < ActiveInteraction::Base
      hash :headers { string :Authorization }
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
        return nil unless headers["Authorization"].present?
        token = headers["Authorization"].split(" ").last
        errors.add(:token, "Missing token") if token&.blank?
        token ? token : nil
      end
    end
  end
end
