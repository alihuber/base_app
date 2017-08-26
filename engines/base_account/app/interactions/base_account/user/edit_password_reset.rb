module BaseAccount
  module User
    class EditPasswordReset < ActiveInteraction::Base

      def execute
        PasswordReset.new
      end


      private
      class PasswordReset
        include ActiveModel::Model
        attr_accessor :password
        validates :password, presence: true
      end
    end
  end
end
