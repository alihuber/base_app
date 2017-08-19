module BaseAuth
  class User
    class Session < ActiveInteraction::Base
      object  :user,        default: nil, class: User
      string  :email,       default: nil
      string  :password,    default: nil
      boolean :remember_me, default: false

      validates :email, :password, presence: true

      def to_model
        Login.new
      end


      def execute
        @user = BaseAuth::User.find_by(email: email)
        if @user && @user.authenticate(password)
          true
        else
          errors.add(:user, "authentication failed")
        end
      end

      private
      class Login
        include ActiveModel::Model
        attr_accessor :email, :password, :remember_me
      end
    end
  end
end
