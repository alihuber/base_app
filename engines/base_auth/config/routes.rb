BaseAuth::Engine.routes.draw do

  scope module: :api do
    post "authenticate", to: "authentication#authenticate"
  end

  scope module: :session do
    get    "login"  => "session#new"
    post   "login"  => "session#create"
    delete "logout" => "session#destroy"
  end
end
