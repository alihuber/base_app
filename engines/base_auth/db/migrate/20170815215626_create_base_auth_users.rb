class CreateBaseAuthUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :base_auth_users do |t|
      t.string   :type
      t.string   :email
      t.string   :password_digest
      t.string   :auth_token
      t.string   :password_reset_token
      t.datetime :password_reset_sent_at
    end

    add_index :base_auth_users, :email,                unique: true
    add_index :base_auth_users, :auth_token,           unique: true
    add_index :base_auth_users, :password_reset_token, unique: true
  end
end
