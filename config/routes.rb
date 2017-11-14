Saleshub::Application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'

  devise_for :users
  root :to => 'pages#home'

  namespace :admin do
    resource :configuration, only: [:edit, :update]
    resources :notifications, except: [:show]
  end

  # We will use this namespace instead of admin
  namespace :manage do
    resources :roles
    resources :users do
      member do
        put  :activate
        put  :deactivate
      end
      resource :permissions, only: [:edit, :update]
    end
    resources :messages, only: [:new, :create, :index, :edit, :update, :destroy] do
      collection do
        put :reorder
        get :customer_messaging
        get :briefings
        # get :whats_ups
      end
    end
  end

  scope '/messages', module: 'message', as: 'message' do
    resources :galleries, only: [:destroy] do
      resources :images, only: [:create, :destroy]
    end
  end
  resources :surveys,  only: [:index]

  resources :messages, only: [:index]
  resources :briefings, only: [:index, :show] do
    resources :comments, only: [:create]
  end
  # resources :whats_ups, only: [:new, :create, :index, :show] do
  #   resources :comments, only: [:create]
  # end

  resources :news, controller: :news_entries, except: [:index] do
    collection do
      get :internal
      get :external
    end
  end
  resources :galleries, only: [:show] do
    resources :folders, only: [:show] do
      resources :assets, only: [:index] do
        member do
          get :manifest
        end
      end
    end
  end
  resources :notifications, only: [] do
    put :close, on: :member
  end

  match '/news', to: 'news_entries#index', via: :get
  match '/taylor-news', to: 'news_entries#internal-news.html.slim', via: :get
  match '/industry-news', to: 'news_entries#external-news.html.slim', via: :get
  match '/resources', to: 'pages#resources', via: :get
  match '/home/create_survey', to: 'pages#create_survey', via: :post
  match '/static_message', to: 'pages#static_message', via: :get
end
