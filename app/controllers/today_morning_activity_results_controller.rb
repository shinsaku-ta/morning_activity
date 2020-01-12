class TodayMorningActivityResultsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :update, only: %i[new]

  def new; end

  # 本日のstateを確認(ボタンの表示・非表示に使用)
  def show
    @day_result = current_user.morning_activity_results.where(execution_at: Date.current.all_day, state: :not_implemented)
    respond_to do |format|
      format.html
      format.json { render json: @day_result }
    end
  end

  def update
    # 本日かつstateが朝活予定日のデータを取得
    @result = current_user.morning_activity_results.find_by(execution_at: Date.current.all_day, state: :not_implemented )

    # データを取得できたら、stateを朝活予定日から朝活成功に変更し保存する
    if @result
      unless @result.update(state: :success)
        redirect_to root_path, danger: 'データの更新に失敗しました。'
      end
    end
  end
end
