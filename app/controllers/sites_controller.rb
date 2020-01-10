class SitesController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
    redirect_to morning_active_path(current_user.id) if logged_in?
  end

  def terms; end
end
