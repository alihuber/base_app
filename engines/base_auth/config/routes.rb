BaseAuth::Engine.routes.draw do
  scope module: :user do
    get    "login"    => "session#new"
    post   "login"    => "session#create"
    delete "logout"   => "session#destroy"

    # get    "password_reset"        => "password_reset#new"
    # post   "password_reset"        => "password_reset#create"
    # get    "password_reset/:token" => "password_reset#edit",
    #                                   as: "do_password_reset"
    # post   "password_reset/:token" => "password_reset#update"
  end
end
