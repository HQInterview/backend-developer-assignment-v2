class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login, except: :not_authenticated

  NOT_LOGGED_IN_MSG = "Operation failed! Please log in first.".freeze

  protected

  def not_authenticated
    respond_to do |format|
      format.html { redirect_to login_path, alert: NOT_LOGGED_IN_MSG }
      format.json { render plain: NOT_LOGGED_IN_MSG, status: :unauthorized }
    end
  end
end
