Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount ActionCable.server   => "/cable"

  mount BaseAdmin::Engine    => "/"
  mount BaseAccount::Engine  => "/"
  mount BaseAuth::Engine     => "/"
  mount BaseApi::Engine      => "/"
  mount BaseMessages::Engine => "/"

  root to: "index#index"
end
