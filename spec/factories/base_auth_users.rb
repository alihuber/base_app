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

FactoryGirl.define do
  factory :user, class: BaseAuth::User do
    email      { Faker::Internet.email }
    password   { Faker::Internet.password }
    auth_token { SecureRandom.urlsafe_base64(24) }

    factory :admin_user, class: BaseAuth::User::AdminUser
  end
end

