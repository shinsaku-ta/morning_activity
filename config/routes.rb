Rails.application.routes.draw do
  root 'sites#index'

  get 'sites/terms', to: 'sites#terms'
  get 'picture_settings/index', to: 'picture_settings#index'
  post 'picture_settings/create', to: 'picture_settings#create'

  get 'accounts/index', to: 'accounts#index'
  get 'accounts/delete_confirm', to: 'accounts#delete_confirm'
  get 'accounts/delete_completed', to: 'accounts#delete_completed'
  post 'accounts/destroy', to: 'accounts#destroy'

  resources :morning_actives, only: %i[show create destroy]
  get 'check_date', to: 'morning_actives#check_date'
  get 'check_now_state', to: 'morning_actives#check_now_state'
  resources :activity_plans, only: %i[new]

  #twitter認証用
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  post 'oauth/logout', to: 'oauths#logout'
end
