class AccountsController < ApplicationController
  # アカウントを削除した場合に削除完了ページに飛べないため追加
  skip_before_action :require_login, raise: false, only: %i[delete_completed]

  def index
    @user = User.find(current_user.id)
  end

  def destroy
    @user = User.find(current_user.id)
    @user.destroy
    session[:user_id] = nil
    redirect_to accounts_delete_completed_path
  end

  def delete_confirm; end

  def delete_completed; end
end
