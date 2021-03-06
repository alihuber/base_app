# == Schema Information
#
# Table name: base_auth_users
#
#  id                     :integer          not null, primary key
#  type                   :string(255)
#  email                  :string(255)
#  password_digest        :string(255)
#  auth_token             :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#
# Indexes
#
#  index_base_auth_users_on_auth_token            (auth_token) UNIQUE
#  index_base_auth_users_on_email                 (email) UNIQUE
#  index_base_auth_users_on_password_reset_token  (password_reset_token) UNIQUE
#

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
