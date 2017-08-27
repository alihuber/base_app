module BaseAccount
  module User
    class UpdateUser < ActiveInteraction::Base
      object :user, class: BaseAuth::User
      string :email, :password, :password_confirmation

      validates :password, length: { minimum: 6 }, allow_blank: true

      def execute
        return false unless passwords_equal?
        user.email    = email if email? && !email.blank?
        user.password = password if password? && !password.blank?

        user.save ? user : errors.merge!(user.errors)
      end

      private
      def passwords_equal?
        if !password.blank? && !password_confirmation.blank? &&
            !(password == password_confirmation)
          errors.add(:password, "passwords do not match")
          false
        else
          true
        end
      end
    end
  end
end
