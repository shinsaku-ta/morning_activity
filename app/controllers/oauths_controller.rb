class OauthsController < ApplicationController
  skip_before_action :require_login, raise: false

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]

    if @user = login_from(provider)
      redirect_to morning_active_path(current_user), success: "#{provider.titleize}でログインしました。"
    else
      begin
        #twitter情報取得
        @user = build_from(provider)

        @user.authentications.build(uid: @user_hash[:uid], provider: provider, access_token: @access_token.token)
        @user.download_and_attach_avatar(@user_hash[:user_info]['profile_image_url_https'])
        @user.save

        reset_session
        auto_login(@user)
        redirect_to sites_terms_path
      rescue
        redirect_to root_path, danger: "#{provider.titleize}でログイン出来ませんでした。"
      end
    end
  end

  def logout
    session[:user_id] = nil
    redirect_to root_path, success: 'ログアウトしました。'
  end
end
