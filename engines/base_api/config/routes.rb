BaseApi::Engine.routes.draw do

  get "users", to: "users#index", defaults: { format: 'json' }
end
