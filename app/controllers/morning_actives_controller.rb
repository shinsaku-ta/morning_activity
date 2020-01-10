class MorningActivesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    if params[:month]
      range = params[:month].to_date.all_month
    else
      range = Date.current.all_month
    end
    @month_results = current_user.morning_activity_results.where(execution_at: range)
    @day_results = check_now_state

    respond_to do |format|
      format.html
      format.json { render json: [month: @month_results, day: @day_results] }
    end
  end

  def create
    @morning_activity_result = current_user.morning_activity_results.build(execution_at: params[:click_day].to_date, state: :not_implemented)
    @morning_activity_result.save

    respond_to do |format|
      format.html
      format.json { render json: current_user }
    end
  end

  def destroy
    @morning_activity_result = current_user.morning_activity_results.find_by!(execution_at: params[:click_day].to_date, state: :not_implemented)
    if @morning_activity_result
      @morning_activity_result.destroy
    end

    respond_to do |format|
      format.html
      format.json { render json: current_user }
    end
  end

  # 本日のstateを確認(ボタンの表示・非表示に使用)
  def check_now_state
    @day_results = current_user.morning_activity_results.where(execution_at: Date.current, state: :not_implemented)
    return @day_results
  end

  # クリックした日付が登録されているか判定
  def check_date
    @morning_activity_results = current_user.morning_activity_results.where(execution_at: params[:click_day].to_date)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @morning_activity_results }
    end
  end
end
