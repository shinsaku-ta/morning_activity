class ActivityPlansController < ApplicationController
  before_action :change_state, only: %i[new]

  def new; end

  def change_state
    @user = User.find(current_user.id)

    # 今日の始まりから終わりの範囲を取得
    range = Date.today.beginning_of_day..Date.today.to_date.end_of_day
    # 上記の範囲かつstateが2(朝活予定日)のデータを取得
    @result = @user.morning_activity_results.find_by(execution_at: range, state: :not_implemented )

    # データを取得できたら、stateを(朝活予定日)→から(朝活成功)に変更し保存する
    if @result
      unless @result.update(state: :success)
        redirect_to root_path, danger: 'データの更新に失敗しました。'
      end
    end
  end
end
