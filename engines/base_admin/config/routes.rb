BaseAdmin::Engine.routes.draw do
  scope module: :admin do
    get "admin_dashboard"  => "dashboard#index"
    post "publish_message" => "dashboard#publish_message"
  end
end
