Rails.application.routes.draw do
  root 'sites#index'

  get 'site/term', to: 'sites#term'
  # resource :picture_setting, only: %i[show create destroy]
  resource :post_picture, only: %i[show create destroy]

  # get 'accounts/index', to: 'accounts#index'
  # get 'accounts/delete_confirm', to: 'accounts#delete_confirm'
  # get 'accounts/delete_completed', to: 'accounts#delete_completed'
  # post 'accounts/destroy', to: 'accounts#destroy'

  # get 'accounts/index', to: 'accounts#index'
  # get 'account/show', to: 'accounts#show'
  get 'account/delete_confirm', to: 'accounts#delete_confirm'
  get 'account/delete_completed', to: 'accounts#delete_completed'
  # post 'account/destroy', to: 'accounts#destroy'
  resource :account, only: %i[show destroy]

  resources :morning_activity_results, only: %i[index show create destroy]
  resource :today_morning_activity_result, only: %i[new show update]
  # resources :activity_plans, only: %i[new]
  # resource :activity_plan, only: %i[new]

  #twitter認証用
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  post 'oauth/logout', to: 'oauths#logout'
end
