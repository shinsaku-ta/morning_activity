class TodayMorningActivityResultsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :update, only: %i[new]

  def new; end

  # 本日のデータ取得
  def show
    @day_result = current_user.morning_activity_results.find_by(execution_at: Date.current.all_day)
    respond_to do |format|
      format.json { render json: @day_result }
    end
  end

  def update
    @day_result = current_user.morning_activity_results.find_by(execution_at: Date.current.all_day, state: :not_implemented)
    return unless @day_result

    if @day_result.success!
      flash[:success] = 'データの更新に成功しました。'
    else
      redirect_to root_path, danger: 'データの更新に失敗しました。'
    end
  end
end
