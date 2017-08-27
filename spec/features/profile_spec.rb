require "rails_helper"

feature "profile editing" do
  let(:user) { create :user }

  scenario "update all data" do
    login(user)
    visit base_account.profile_path(user.id)

    fill_in "user_email", with: "new@email.com"
    fill_in "newPasswordInput", with: "123456"
    fill_in "passwordConfirmationInput", with: "123456"
    click_button "submitProfile"

    expect(page).to have_css ".alert-success"
    expect(current_path).to eq base_account.profile_path(user.id)
    expect(user.reload.email).to eq "new@email.com"

    # login with new credentials
    click_link "logout_link"

    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email",    with: "new@email.com"
    fill_in "session_create_session_login_password", with: "123456"
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
  end

  scenario "update only e-mail-address" do
    login(user)
    visit base_account.profile_path(user.id)

    fill_in "user_email", with: "new@email.com"
    click_button "submitProfile"

    expect(page).to have_css ".alert-success"
    expect(current_path).to eq base_account.profile_path(user.id)
    expect(user.reload.email).to eq "new@email.com"

    # login with new credentials
    click_link "logout_link"

    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email",    with: "new@email.com"
    fill_in "session_create_session_login_password", with: user.password
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
  end

  scenario "update only password" do
    login(user)
    visit base_account.profile_path(user.id)

    fill_in "newPasswordInput", with: "123456"
    fill_in "passwordConfirmationInput", with: "123456"
    click_button "submitProfile"

    expect(page).to have_css ".alert-success"
    expect(current_path).to eq base_account.profile_path(user.id)

    # login with new credentials
    click_link "logout_link"

    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email",    with: user.email
    fill_in "session_create_session_login_password", with: "123456"
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
  end

  scenario "invalid password params" do
    login(user)
    visit base_account.profile_path(user.id)

    fill_in "newPasswordInput", with: "123456"
    fill_in "passwordConfirmationInput", with: "654321"
    click_button "submitProfile"

    expect(page).to have_css ".alert-danger"
    expect(current_path).to eq base_account.profile_path(user.id)
  end

  scenario "access not existing user" do
    login(user)
    begin
      visit base_account.profile_path(user.id + 42)
    rescue(ActionController::RoutingError) => e
      expect(e.message).to eq "Not Found"
    end
  end

  scenario "profile JavaScript validations", js: true do
    login(user)
    visit base_account.profile_path(user.id)

    # first state: diabled
    expect(page).to have_css("#submitProfile[disabled]")

    # validations
    # enter valid email address: button is not disabled
    expect(page).to have_css("#submitProfile[disabled]")
    fill_in "user_email", with: "new@email.com"
    expect(page).not_to have_css("#submitProfile[disabled]")

    # start typing in new invalid password: disabled
    fill_in "newPasswordInput", with: "1"
    expect(page).to have_css(".ng-invalid-minlength")
    expect(page).to have_css("#submitProfile[disabled]")

    # passwords do not match: tooltip
    fill_in "newPasswordInput", with: "123456"
    fill_in "passwordConfirmationInput", with: "654321"
    expect(page).to have_css("#submitProfile[disabled]")
    expect(page).to have_css(".tooltip-arrow")

    # no passwords: valid again
    fill_in "newPasswordInput", with: ""
    fill_in "passwordConfirmationInput", with: ""
    expect(page).not_to have_css("#submitProfile[disabled]")
    expect(page).not_to have_css(".tooltip-arrow")
  end
end
