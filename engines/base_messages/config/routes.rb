BaseMessages::Engine.routes.draw do
  scope module: :user do
    get "user_dashboard" => "dashboard#index"
  end
end
