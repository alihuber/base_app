module BaseAuth
  class User < ApplicationRecord
    has_secure_password

    def admin?
      false
    end

    class AdminUser < self
      def admin?
        true
      end
    end
  end
end
