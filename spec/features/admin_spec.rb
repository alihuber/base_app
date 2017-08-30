require "rails_helper"

feature "admin dashboard" do
  let!(:user1)      { create :user }
  let!(:user2)      { create :user }
  let!(:admin_user) { create :admin_user }


  scenario "display users", js: true do
    login(admin_user)
    expect(page).to have_css ".alert-success"
    expect(page).to have_text(user1.email)
    expect(page).to have_text(user2.email)
    expect(page).to have_text(admin_user.email)
    expect(page).to have_css(".glyphicon-check", count: 1)

    click_button "editModeButton"
    expect(page).to have_css(".glyphicon-remove", count: 2)
    expect(page).to have_field("innerEmail", with: user1.email)
    expect(page).to have_field("innerEmail", with: user2.email)
    expect(page).to have_field("innerEmail", with: admin_user.email)
  end

  scenario "udpate user", js: true do
    login(admin_user)
    expect(page).to have_css ".alert-success"
    expect(page).to have_text(user1.email)
    click_button "editModeButton"
    expect(page).to have_css(".glyphicon-remove", count: 2)

    fill_in "userInput#{user1.id}", with: "new_email"
    expect(page).not_to have_css("#saveUser#{user1.id}")
    fill_in "userInput#{user1.id}", with: "new_email@bar.com"
    click_link "saveUser#{user1.id}"
    expect(page).to have_css ".alert-success"
    user1.reload
    expect(user1.email).to eq "new_email@bar.com"

    # login with updated user
    logout
    expect(page).to have_css ".alert-success"
    login(user1)
    expect(page).to have_css ".alert-success"
  end

  scenario "create user", js: true do
    login(admin_user)
    expect(page).to have_css ".alert-success"

    click_button "newUserButton"
    expect(page).to have_css("#createUserButton[disabled]")

    #update user
    new_email = "new_email@bar.com"
    fill_in "newUserEmail", with: "new_email"
    expect(page).to have_css("#createUserButton[disabled]")
    fill_in "newUserPassword", with: "123"
    expect(page).to have_css("#createUserButton[disabled]")
    fill_in "newUserEmail", with: new_email
    fill_in "newUserPassword", with: "1234567"
    expect(page).not_to have_css("#createUserButton[disabled]")

    expect {
      click_button "createUserButton"
    }.to change { BaseAuth::User.count }.by(1)

    expect(page).to have_css ".alert-success"
    expect(page).to have_text(new_email)

    # login with created user
    logout
    visit main_app.root_path
    click_link "login_link"
    fill_in "session_create_session_login_email",    with: new_email
    fill_in "session_create_session_login_password", with: "1234567"
    click_button "submit_login"

    expect(page).to have_css ".alert-success"
  end

  scenario "delete user", js: true do
    login(admin_user)
    expect(page).to have_css ".alert-success"
    expect(page).to have_text(user1.email)
    click_button "editModeButton"
    expect(page).to have_css(".glyphicon-remove", count: 2)

    click_link "deleteUser#{user1.id}"

    expect(page).to have_css ".alert-success"
    expect(page).not_to have_text(user1.email)
  end
end
