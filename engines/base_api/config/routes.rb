BaseApi::Engine.routes.draw do
  get "users",          to: "users#index",   defaults: { format: 'json' }
  get "user/id/:id",    to: "users#show",    defaults: { format: 'json' }
  put "user/id/:id",    to: "users#update",  defaults: { format: 'json' }
  post "users",         to: "users#create",  defaults: { format: 'json' }
  delete "user/id/:id", to: "users#destroy", defaults: { format: 'json' }
end
