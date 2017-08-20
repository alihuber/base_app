require "spec_helper"

feature "user authentication" do
  let!(:admin_user) { create :admin_user }

  scenario "request password reset fails (no email)" do
    visit main_app.root_path
    click_link "login_link"
    click_link "forgot_password_link"
    click_button "submit_password_reset_request"

    expect(page).to have_css ".alert-danger"
    expect(current_path).to eq base_auth.password_reset_path
  end

  scenario "request password reset fails (wrong email)" do
    visit main_app.root_path
    click_link "login_link"
    click_link "forgot_password_link"
    fill_in "user_request_password_reset_password_reset_email",
      with: "foo@bar.com"
    click_button "submit_password_reset_request"

    expect(page).to have_css ".alert-danger"
    expect(current_path).to eq base_auth.password_reset_path
  end

  scenario "request password reset succeeds" do
    expect(admin_user.password_reset_sent_at).to be_nil
    expect(admin_user.password_reset_token).to be_nil

    visit main_app.root_path
    click_link "login_link"
    click_link "forgot_password_link"
    fill_in "user_request_password_reset_password_reset_email",
      with: admin_user.email
    expect {
      click_button "submit_password_reset_request"
    }.to change { admin_user.reload.password_reset_sent_at }
     .and change { admin_user.reload.password_reset_token }
     .and change { ActionMailer::Base.deliveries.count }.by(1)

    expect(page).to have_css ".alert-success"
    expect(current_path).to eq main_app.root_path

    expect(admin_user.password_reset_sent_at.to_date).to eq Time.zone.today
    expect(admin_user.password_reset_token).to be_present
  end
end
