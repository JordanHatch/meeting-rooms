Rails.application.routes.draw do
  resources :rooms do
    collection do
      post :import_all
    end

    member do
      post :import
    end
  end

  root to: redirect('/rooms')
end
