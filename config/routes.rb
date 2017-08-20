Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount BaseAuth::Engine => "/"
  mount BaseApi::Engine  => "/"

  root to: "index#index"
end
