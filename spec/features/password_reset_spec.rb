require "spec_helper"

feature "user authentication" do
  let!(:admin_user) { create :admin_user }

  scenario "password reset" do
    # create reset token manually
    visit base_account.password_reset_path
    fill_in "user_request_password_reset_password_reset_email",
      with: admin_user.email
    click_button "submit_password_reset_request"

    expect(current_path).to eq main_app.root_path
    expect(page).to have_css ".alert-success"

    admin_user.reload

    reset_url =
      base_account.do_password_reset_path(token: admin_user.password_reset_token)

    # no new password: show errors on form
    visit reset_url
    click_button "submit_password_reset"

    expect(page).to have_css "form#new_user_edit_password_reset_password_reset"
    expect(page).to have_css ".alert-danger"

    # password too short: show errors on form
    fill_in "user_edit_password_reset_password_reset_password", with: "short"
    click_button "submit_password_reset"
    expect(page).to have_css "form#new_user_edit_password_reset_password_reset"
    expect(page).to have_css ".alert-danger"

    # password reset succeeds
    fill_in "user_edit_password_reset_password_reset_password", with: "new_password"
    expect {
      click_button "submit_password_reset"
    }.to change { admin_user.reload.password_reset_sent_at }
     .and change { admin_user.reload.password_reset_token }
     .and change { admin_user.reload.password_digest }

    expect(page).to have_css ".alert-success"
    expect(current_path).to eq main_app.root_path

    expect(admin_user.password_reset_sent_at).to be_nil
    expect(admin_user.password_reset_token).to be_nil

    # login with new password succeeds
    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email", with: admin_user.email
    fill_in "session_create_session_login_password", with: "new_password"
    click_button "submit_login"
    expect(page).to have_css ".alert-success"
  end

  scenario "password reset with wrong token" do
    visit base_account.do_password_reset_path(token: "wrong")
    fill_in "user_edit_password_reset_password_reset_password",
      with: "new_password"
    click_button "submit_password_reset"

    expect(current_path).to(
      eq base_account.do_password_reset_path(token: "wrong")
    )
    expect(page).to have_css ".alert-danger"
  end

  scenario "password reset call with blank token" do
    visit base_account.do_password_reset_path(token: "")

    expect(current_path).to eq base_account.password_reset_path + "/"
  end
end
