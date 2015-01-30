Rails.application.routes.draw do
  resources :rooms do
    member do
      post :import
    end
  end

  root to: redirect('/rooms')
end
