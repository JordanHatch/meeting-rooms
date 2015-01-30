Rails.application.routes.draw do
  resources :rooms

  root to: redirect('/rooms')
end
