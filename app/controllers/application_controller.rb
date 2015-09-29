class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :authorize!

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authorize!
    redirect_to root_path, notice: 'Please log in or signup' unless current_user
  end
end
