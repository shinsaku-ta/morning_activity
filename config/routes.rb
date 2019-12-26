Rails.application.routes.draw do
  root 'sites#index'

  get 'sites/terms', to: 'sites#terms'
  get 'picture_settings/index', to: 'picture_settings#index'
  get 'morning_actives', to: 'morning_actives#index'

  #twitter認証用
  post 'oauth/callback', to: 'oauths#callback'
  get 'oauth/callback', to: 'oauths#callback'
  get 'oauth/:provider', to: 'oauths#oauth', as: :auth_at_provider
  post 'oauth/logout', to: 'oauths#logout'
end
