module BaseAuth
  class User
    class RequestPasswordReset < ActiveInteraction::Base

      def execute
        PasswordReset.new
      end


      private
      class PasswordReset
        include ActiveModel::Model
        attr_accessor :email
        validates :email, presence: true
      end
    end
  end
end
