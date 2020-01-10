class ActivityPlansController < ApplicationController
  before_action :change_state, only: %i[new]

  def new; end

  def change_state
    # 本日かつstateが朝活予定日のデータを取得
    @result = current_user.morning_activity_results.find_by(execution_at: Date.current, state: :not_implemented )

    # データを取得できたら、stateを朝活予定日から朝活成功に変更し保存する
    if @result
      unless @result.update(state: :success)
        redirect_to root_path, danger: 'データの更新に失敗しました。'
      end
    end
  end
end
