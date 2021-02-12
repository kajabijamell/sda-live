require 'sidekiq/web'
Rails.application.routes.draw do

  namespace :members do
    get 'home/index'
  end
  post 'notify/mux'
  post 'notify/stripe'
  post 'sns/notify' => 'sns_hls_notify#notify'

  get 'embed/:embed_code' => 'embed#index'

  post 's3/fetch_signed_url' => 'home#fetch_signed_url'

  get '/privacy' => 'home#privacy'
  get '/terms' => 'home#terms'

  authenticated :user, lambda { |u| u.admin? } do
    # Only allow admin to delete it's profile
    delete 'settings/profile' => 'settings#destroy'

    namespace :admin, path: '/' do

      root to: 'dashboard#index', as: :root
      get '/dashboard' => 'dashboard#index', as: :dashboard
      get 'website/edit'
      post 'website/update'
      patch 'website/update'

      resources :live_streams, only: %i[index create], path: 'streams'
      resources :live_streams, only: %i[destroy show new], path: 'stream'
      get 'stream/:id/targets/new' => 'live_streams#new_target', as: :new_target
      post 'stream/:id/targets/create' => 'live_streams#create_target', as: :create_target
      delete 'stream/:id/targets/:target_id' => 'live_streams#destroy_target', as: :destroy_target

      resources :media_sermons, only: %i[index create], path: 'sermons'
      resources :media_sermons, except: %i[index create], path: 'sermon'

      resources :media_images, path: 'gallery'

      resources :events, only: %i[index create], path: 'events'
      resources :events, except: %i[index create], path: 'event'

      resources :news, only: %i[index create], path: 'news'
      resources :news, except: %i[index create], path: 'article'

      resources :members, only: %i[index create], path: 'members'
      resources :members, except: %i[index create], path: 'member'

      get '/church' => 'church#show', as: :my_church
      get 'church/edit', as: :edit_church
      patch 'settings/church_update', as: :update_my_church
      patch 'settings/subdomain_update', as: :update_my_subdomain

      # Payment methods APIs
      resources :payment_methods, only: %i[index create destroy new]
      post '/payment_methods/:id/default' => 'payment_methods#default', as: :set_default_payment_method

      # Subscriptions
      get '/subscriptions' => 'subscriptions#index', as: :subscriptions
      delete '/subscriptions/cancel' => 'subscriptions#cancel', as: :cancel_subscription
      post '/subscriptions/restart' => 'subscriptions#restart', as: :restart_subscription
      post '/subscriptions/:id/choose' => 'subscriptions#choose', as: :choose_subscription
      post '/subscriptions/:id/change' => 'subscriptions#change', as: :change_subscription
    end
  end

  # User settings
  get 'settings/profile'
  patch 'settings/profile' => 'settings#save_profile'


  devise_for :users, controllers: {
    registrations: 'user/registrations',
    omniauth_callbacks: 'admin/omniauth'
  }

  devise_scope :user do
    get 'invitation/accept', as: :accept_invitation
    post 'invitation/complete', as: :complete_invitation
  end

  authenticated :user, lambda { |u| u.super_admin? } do
    mount Sidekiq::Web => '/sidekiq'

    root to: 'home#index', as: :super_admin_root
    resources :admins

    namespace :super_admin, path: '/' do
      resources :subscriptions
    end
  end

  # Member Routes
  authenticated :user, lambda { |u| u.member? } do
    root to: 'members/home#index', as: :member_home
  end

  unauthenticated :user do
    root to: 'home#index', constraints: { subdomain: 'www' }

    # Public routes
    constraints lambda { |req| req.subdomain != 'www' } do
      root to: 'public/home#index', as: :church_subdomain

      namespace :public, path: '/' do
        get 'news' => 'news#index'
        get 'article/:id' => 'news#show', as: :article

        get 'sermons' => 'sermons#index'

        get 'events' => 'events#index'
        get 'event/:id' => 'events#show', as: :event
        get 'live' => 'live_streams#index', as: :streams
      end
    end
  end
end
