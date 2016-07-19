Rails.application.routes.draw do
  root to: redirect("/users")
  resources :users, only: [:index, :create, :new, :show]
end
