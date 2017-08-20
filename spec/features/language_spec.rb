require "rails_helper"

feature "language detection" do
  scenario "default language without any settings" do
    visit main_app.root_path
    click_link "login_link"

    expect(page).to have_text("Passwort vergessen?")
  end

  scenario "default language (:de) for unkown keys" do
    page.driver.header "Accept-Language", "jp"
    visit main_app.root_path
    click_link "login_link"

    expect(page).to have_text("Passwort vergessen?")
  end

  scenario "second language with set browser header" do
    page.driver.header "Accept-Language", "en-US"
    visit main_app.root_path
    click_link "login_link"

    expect(page).not_to have_text("Passwort vergessen?")
    expect(page).not_to have_text("Forgot password?")

    # reset I18n.locale for later tests
    I18n.locale = :de
  end
end
