BaseApi::Engine.routes.draw do
  post "authenticate", to: "authentication#authenticate"

  get "users", to: "users#index"
end
