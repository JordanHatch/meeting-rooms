Rails.application.routes.draw do
  resources :rooms do
    collection do
      get :dashboard, to: 'rooms#collection_dashboard'
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
