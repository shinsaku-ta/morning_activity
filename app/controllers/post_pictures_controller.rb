class PostPicturesController < ApplicationController

  def show; end

  def create
    if params[:post_picture]
      current_user.post_picture.attach(params[:post_picture])
      redirect_to morning_activity_results_path(month: Date.current), success: '画像を登録しました。'
    else
      flash[:danger] = '画像が選択されていません。'
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    if current_user.post_picture.attached?
      current_user.post_picture.purge
    end
    redirect_to morning_activity_results_path(month: Date.current), success: 'デフォルト画像を登録しました。'
  end
end
