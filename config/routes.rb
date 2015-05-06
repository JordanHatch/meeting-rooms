Rails.application.routes.draw do
  resources :rooms do
    collection do
      post :import_all
    end

    member do
      get :dashboard
      post :import
    end
  end

  get '/dashboards/rooms/:id' => 'legacy_redirects#room_dashboard'

  root to: redirect('/rooms')
end
