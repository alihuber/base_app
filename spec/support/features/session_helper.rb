module Features
  module SessionHelpers
    def login(user)
      visit base_auth.login_path
      fill_in "user_session_login_email",    with: user.email
      fill_in "user_session_login_password", with: user.password
      click_button "submit_login"
    end


    def logout
      click_link "logout_link"
    end
  end
end
