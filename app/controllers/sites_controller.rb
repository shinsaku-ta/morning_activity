class SitesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    redirect_to morning_activity_results_path if logged_in?
  end

  def terms; end
end
