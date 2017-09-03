require "rails_helper"

feature "session handling" do
  let(:user) { create :user }

  scenario "login" do
    visit main_app.root_path

    click_link "login_link"
    fill_in "session_create_session_login_email",    with: user.email
    fill_in "session_create_session_login_password", with: user.password
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
    expect(get_me_the_cookie("auth_token")[:expires]).to be_nil
    expect(current_path).to eq base_messages.user_dashboard_path
  end

  scenario "login with 'remember_me'" do
    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email",    with: user.email
    fill_in "session_create_session_login_password", with: user.password
    check "session_create_session_login_remember_me"
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
    expect(get_me_the_cookie("auth_token")[:value]).to eq user.auth_token
    expect(get_me_the_cookie("auth_token")[:expires].year).to(
      eq Time.zone.today.year + 20)
    expect(current_path).to eq base_messages.user_dashboard_path
  end

  scenario "login fails" do
    visit base_auth.login_path
    fill_in "session_create_session_login_email",    with: user.email
    fill_in "session_create_session_login_password", with: "wrong"
    click_button "submit_login"

    expect(page).to have_css ".alert-danger"
    expect(current_path).to eq base_auth.login_path
  end

  scenario "logout" do
    login(user)
    expect(get_me_the_cookie("auth_token")[:value]).to eq user.auth_token
    expect(page).to have_css ".alert-success"
    expect(current_path).to eq base_messages.user_dashboard_path

    click_link "logout_link"

    expect(get_me_the_cookie("auth_token")[:value]).to eq ""
    expect(page).to have_css ".alert-success"
    expect(current_path).to eq main_app.root_path
  end

  scenario "login JavaScript validations", js: true do
    visit main_app.root_path

    click_link "login_link"
    expect(page).to have_css("#submit_login[disabled]")

    fill_in "session_create_session_login_email",    with: "foo"
    fill_in "session_create_session_login_password", with: "1"
    expect(page).to have_css("#submit_login[disabled]")
    expect(page).to have_css(".ng-invalid-email")
    expect(page).to have_css(".ng-invalid-minlength")

    fill_in "session_create_session_login_email",    with: "foo@mar.com"
    fill_in "session_create_session_login_password", with: "1234567"
    expect(page).not_to have_css("#submit_login[disabled]")
    expect(page).not_to have_css(".ng-invalid-email")
    expect(page).not_to have_css(".ng-invalid-minlength")
  end
end
