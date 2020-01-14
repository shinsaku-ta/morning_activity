Rails.application.routes.draw do
  root 'sites#index'

  get 'site/term', to: 'sites#term'
  resource :post_picture, only: %i[show create destroy]

  resource :account, only: %i[show destroy]
  get 'account/delete_confirm', to: 'accounts#delete_confirm'
  get 'account/delete_completed', to: 'accounts#delete_completed'

  resources :morning_activity_results, only: %i[index show create destroy]
  resource :today_morning_activity_result, only: %i[new show update]

  #twitter認証用
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  post 'oauth/logout', to: 'oauths#logout'
end
