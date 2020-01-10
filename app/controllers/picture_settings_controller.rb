class PictureSettingsController < ApplicationController
  def index
    @user = User.find(current_user.id)
  end

  def create
    @user = User.find(current_user.id)
    if params[:register]
      @user.post_picture.attach(params[:user][:post_picture])
      redirect_to morning_active_path(current_user), success: '画像を登録しました。'
    else
      if @user.post_picture.attached?
        @user.post_picture.purge
      end
      redirect_to morning_active_path(current_user), success: 'デフォルト画像を登録しました。'
    end
  end

  private

  def user_params
    params.require(:user)
  end
end
