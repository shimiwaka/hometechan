Rails.application.routes.draw do
  get 'static/policy'
  get 'homeru/create'
  get 'follow/:screen_name', to: 'follow#create'
  get 'unfollow/:screen_name', to: 'follow#disable'
  get 'status/:screen_name', to: 'users#status'

  get 'resend', to: 'users#lost_mail'
  post 'resend', to: 'users#resend'

  get 'homeru/create/:to/:type', to: 'homeru#create'

  post 'homete/create', to: 'homete#create'
  get 'homete/edit/:id', to: 'homete#edit'
  post 'homete/update/:id', to: 'homete#update'
  get 'homete/destroy/:id', to: 'homete#destroy'
  get 'homete/destroy_ajax/:id', to: 'homete#destroy_ajax'
  get 'homete/search', to: 'homete#search'

  get 'mute/enable/:screen_name', to: 'mute#enable'
  get 'mute/disable/:screen_name', to: 'mute#disable'
  get 'mutes', to: 'mute#mutes_list'
  get 'admin', to: 'admin#top'
  get 'admin/destroy_user/:id', to: 'admin#destroy_user'
  get 'admin/lock/:id', to: 'admin#lock'
  get 'admin/unlock/:id', to: 'admin#unlock'
  get 'admin/all', to: 'admin#all'

  get 'follows', to: 'follow#follows_list'
  get 'followers', to: 'follow#followers_list'
  get 'notifications', to: 'notification#show'

  get 'popular', to: 'homete#popular'
  get 'homete/:id', to: 'homete#show'

  get 'privacy-policy', to: 'static#policy'
  get 'terms', to: 'static#terms'
  get 'help', to: 'static#help'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  devise_for :users, controllers: {
     registrations: 'users/registrations',
     sessions: 'users/sessions',
     omniauth_callbacks: 'users/omniauth_callbacks'
  }
  root to: 'home#index'
end
