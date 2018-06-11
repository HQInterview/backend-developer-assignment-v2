class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login, except: :not_authenticated

  protected

  def not_authenticated
    redirect_to login_path, alert: "Operation failed! Please log in first."
  end
end
