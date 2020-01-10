class PictureSettingsController < ApplicationController

  def index; end

  def create
    if params[:register]
      current_user.post_picture.attach(params[:post_picture])
      redirect_to morning_active_path(current_user), success: '画像を登録しました。'
    else
      if current_user.post_picture.attached?
        current_user.post_picture.purge
      end
      redirect_to morning_active_path(current_user), success: 'デフォルト画像を登録しました。'
    end
  end

  private

  def user_params
    params.require(:user)
  end
end
