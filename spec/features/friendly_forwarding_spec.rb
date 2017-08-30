require "rails_helper"

feature "friendly forwarding" do
  let(:user)       { create :user }
  let(:admin_user) { create :admin_user }

  scenario "forwarding to profile page" do
    visit base_account.profile_path(user.id)
    expect(current_path).to eq base_auth.login_path
    expect(page).to have_css ".alert-danger"

    fill_in "session_create_session_login_email",    with: user.email
    fill_in "session_create_session_login_password", with: user.password
    click_button "submit_login"

    expect(current_path).to eq base_account.profile_path(user.id)
    expect(page).to have_css ".alert-success"
  end

  scenario "forwarding to admin page" do
    visit base_admin.admin_dashboard_path
    expect(current_path).to eq base_auth.login_path
    expect(page).to have_css ".alert-danger"

    fill_in "session_create_session_login_email",    with: admin_user.email
    fill_in "session_create_session_login_password", with: admin_user.password
    click_button "submit_login"

    expect(current_path).to eq base_admin.admin_dashboard_path
    expect(page).to have_css ".alert-success"
  end
end
