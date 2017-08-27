module BaseApi
  module Users
    class CreateUser < ActiveInteraction::Base
      string :email, :password

      validates :email, presence: true
      validates :password, length: { minimum: 6 }

      def execute
        user = BaseAuth::User.new(email: email, password: password)
        user.save ? user : errors.merge!(user.errors)
      end
    end
  end
end
