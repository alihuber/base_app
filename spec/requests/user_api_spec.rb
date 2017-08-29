require "rails_helper"

feature "User API", type: :api do
  let!(:admin_user) { create :admin_user }
  let!(:user)       { create :user }
  let(:admin_token) { JsonWebToken.instance.encode(user_id: admin_user.id) }
  let(:user_token)  { JsonWebToken.instance.encode(user_id: user.id) }

  scenario "authenticate via API with credentials" do
    post "/authenticate", Hash[:authentication =>
                                {:email => user.email,
                                 :password => user.password} ]

    expect(last_response.body).to include '{"auth_token":"ey'
    decoded_token =
      JsonWebToken.instance.decode(JSON.parse(last_response.body)["auth_token"])
    expect(decoded_token[:user_id]).to eq user.id
  end

  scenario "authenticate via API with no headers" do
    post "/authenticate"

    expect(last_response.status).to be 401
    expect(last_response.body).to include "authentication failed"
  end

  scenario "authenticate via API with invalid combination" do
    post "/authenticate", Hash[:authentication =>
                                {:email => user.email,
                                 :password => "some.foo"} ]

    expect(last_response.status).to be 401
    expect(last_response.body).to include "authentication failed"
  end

  scenario "authenticate via API with wrong credentials" do
    post "/authenticate", Hash[:authentication => {:foo => "foo"}]

    expect(last_response.status).to be 401
    expect(last_response.body).to include 'email":['
  end

  scenario "accessing users with no header" do
    get "/users"

    expect(last_response.status).to be 401
  end

  scenario "accessing users resource authenticated as normal user" do
      header "Authorization", user_token
      get "/users"

      expect(last_response.status).to be 401
      expect(last_response.body).to include "Not Authorized"
  end

  scenario "accessing users resource authenticated as admin user" do
    header "Authorization", admin_token
    get "/users"

    expect(last_response.status).to be 200
    expect(last_response.body).to include user.email
    expect(last_response.body).to include user.id.to_s
    expect(last_response.body).to include admin_user.email
    expect(last_response.body).to include admin_user.id.to_s
  end

  scenario "accessing specific user URL authenticated as normal user" do
      header "Authorization", user_token
      get "/user/id/#{user.id}"

      expect(last_response.status).to be 401
      expect(last_response.body).to include "Not Authorized"
  end

  scenario "accessing specific user URL authenticated as admin user" do
      header "Authorization", admin_token
      get "/user/id/#{user.id}"

      expect(last_response.status).to be 200
      expect(last_response.body).to include user.email
      expect(last_response.body).to include user.id.to_s
  end

  scenario "accessing not existent user URL authenticated as admin user" do
      header "Authorization", admin_token
      get "/user/id/#{user.id.to_s + 'abc'}"

      expect(last_response.status).to be 404
  end

  scenario "accessing update user URL authenticated as normal user" do
      header "Authorization", user_token
      put "/user/id/#{user.id}", Hash[:user =>
                                 {:email => user.email,
                                  :password => "some.foo",
                                  :password_confirmation => "some.foo"} ]

      expect(last_response.status).to be 401
      expect(last_response.body).to include "Not Authorized"
  end

  scenario "updating user" do
    header "Authorization", admin_token
    put "/user/id/#{user.id}", Hash[:user =>
                                {:email => "new@example.com",
                                :password => "some.foo",
                                :password_confirmation => "some.foo"} ]

    expect(last_response.status).to be 200
    expect(last_response.body).to include "new@example.com"
    expect(last_response.body).to include user.id.to_s
  end

  scenario "updating user with invalid data" do
    header "Authorization", admin_token
    put "/user/id/#{user.id}", Hash[:user =>
                                {:email => "new@example.com",
                                 :password => "some.oof",
                                 :password_confirmation => "some.foo"} ]

    expect(last_response.status).to be 422
    expect(last_response.body).to eq(
      '{"error":{"password":["passwords do not match"]}}'
    )
  end

  scenario "accessing delete user URL authenticated as normal user" do
      header "Authorization", user_token
      delete "/user/id/#{user.id}"

      expect(last_response.status).to be 401
      expect(last_response.body).to include "Not Authorized"
  end

  scenario "deleting user" do
    header "Authorization", admin_token
    delete "/user/id/#{user.id}"

    expect(last_response.status).to be 200
    expect(last_response.body).to include user.email
    expect(last_response.body).to include user.id.to_s
    expect(BaseAuth::User.count).to eq 1
  end

  scenario "deleting not existent user" do
    header "Authorization", admin_token
    delete "/user/id/#{user.id + 42}"

    expect(last_response.status).to be 404
  end

  scenario "accessing create user URL authenticated as normal user" do
      header "Authorization", user_token
      post "/users", Hash[:user =>
                          {:email => "foo@bar.com",
                           :password => "some.foo"} ]

      expect(last_response.status).to be 401
      expect(last_response.body).to include "Not Authorized"
  end

  scenario "create user" do
    header "Authorization", admin_token
    post "/users", Hash[:user =>
                        {:email => "foo@bar.com",
                         :password => "some.foo"} ]

    expect(last_response.status).to be 201
    expect(last_response.body).to include "foo@bar.com"
  end

  scenario "create invalid user (too short password)" do
    header "Authorization", admin_token
    post "/users", Hash[:user =>
                        {:email => "foo@bar.com",
                          :password => "some"} ]

    expect(last_response.status).to be 422
    expect(last_response.body).to include '{"error":{"password":'
    expect(last_response.body).to include "6"
  end

  scenario "create invalid user (no password)" do
    header "Authorization", admin_token
    post "/users", Hash[:user =>
                        {:email => "foo@bar.com",
                         :password => ""} ]

    expect(last_response.status).to be 422
    expect(last_response.body).to include '{"error":{"password":'
    expect(last_response.body).to include "6"
  end

  scenario "create invalid user (no email)" do
    header "Authorization", admin_token
    post "/users", Hash[:user =>
                        {:email => "",
                         :password => "some.foo"} ]

    expect(last_response.status).to be 422
    expect(last_response.body).to include '{"error":{"email":'
  end
end
