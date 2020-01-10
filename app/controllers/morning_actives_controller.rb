class MorningActivesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    @user = User.find(current_user.id)
    if params[:month]
      range = params[:month].to_date.in_time_zone.all_month
    else
      range = Date.today.in_time_zone.all_month
    end
    @month_results = @user.morning_activity_results.where(execution_at: range)
    @day_results = check_now_state
    respond_to do |format|
      format.html
      format.json { render json: [month: @month_results, day: @day_results] }
    end
  end

  def create
    @user = User.find(current_user.id)
    @morning_activity_result = @user.morning_activity_results.build(user_id: current_user.id, state: :not_implemented, execution_at: params[:click_day].to_date)
    @morning_activity_result.save
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def destroy
    @user = User.find(current_user.id)
    range = params[:click_day].to_date.beginning_of_day..params[:click_day].to_date.end_of_day
    @morning_activity_result = @user.morning_activity_results.find_by!(execution_at: range, state: :not_implemented)
    if @morning_activity_result
      @morning_activity_result.destroy
    end

    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  # 本日のstateを確認(ボタンの表示・非表示に使用)
  def check_now_state
    @user = User.find(current_user.id)
    now_range = Date.today.beginning_of_day..Date.today.end_of_day
    @day_results = @user.morning_activity_results.where(execution_at: now_range, state: :not_implemented)
    return @day_results
  end

  # カレンダーの表示年月で、登録されているデータ一覧取得
  def check_date
    @user = User.find(current_user.id)
    range = params[:click_day].to_date.beginning_of_day..params[:click_day].to_date.end_of_day
    @morning_activity_results = @user.morning_activity_results.where(execution_at: range)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: @morning_activity_results }
    end
  end
end
