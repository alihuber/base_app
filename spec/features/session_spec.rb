require "rails_helper"

feature "session handling" do
  let(:admin_user) { create :admin_user }

  scenario "login" do
    visit main_app.root_path

    # validations
    click_link "login_link"
    click_button "submit_login"
    expect(page).to have_css ".help-block", count: 2


    click_link "login_link"
    fill_in "session_create_session_login_email",    with: admin_user.email
    fill_in "session_create_session_login_password", with: admin_user.password
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
    expect(get_me_the_cookie("auth_token")[:expires]).to be_nil
    expect(current_path).to eq main_app.root_path
  end

  scenario "login with 'remember_me'" do
    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email",    with: admin_user.email
    fill_in "session_create_session_login_password", with: admin_user.password
    check "session_create_session_login_remember_me"
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
    expect(get_me_the_cookie("auth_token")[:value]).to eq admin_user.auth_token
    expect(get_me_the_cookie("auth_token")[:expires].year).to(
      eq Time.zone.today.year + 20)
    expect(current_path).to eq main_app.root_path
  end

  scenario "login fails" do
    visit base_auth.login_path
    fill_in "session_create_session_login_email",    with: admin_user.email
    fill_in "session_create_session_login_password", with: "wrong"
    click_button "submit_login"

    expect(page).to have_css ".alert-danger"
    expect(current_path).to eq base_auth.login_path
  end

  scenario "logout" do
    login(admin_user)
    expect(get_me_the_cookie("auth_token")[:value]).to eq admin_user.auth_token
    expect(page).to have_css ".alert-success"
    expect(current_path).to eq main_app.root_path

    click_link "logout_link"

    expect(get_me_the_cookie("auth_token")[:value]).to eq ""
    expect(page).to have_css ".alert-success"
    expect(current_path).to eq main_app.root_path
  end
end
