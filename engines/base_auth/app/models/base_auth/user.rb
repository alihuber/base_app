module BaseAuth
  class User < ActiveRecord::Base
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
