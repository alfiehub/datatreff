class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def authorize
    redirect_to logg_inn_path, flash: {danger: "Du er ikke logget inn!" } if current_user.nil?
  end

  def authorize_admin
    redirect_to root_path, flash: {danger: "Du har ikke rettigheter til å gjøre dette."} if current_user.nil? || !current_user.admin
  end

  def is_admin?
    !current_user.nil? && current_user.admin
  end

  def render_404
    flash[:danger] = "404 - Denne siden ble ikke funnet."
    redirect_to root_path
  end

  def event_started
    redirect_to root_path if !is_admin? && Time.now < Rails.application.config.event_start
  end

  def event_started?
    !is_admin? || Time.now < Rails.application.config.event_start
  end

  helper_method :is_admin?
  helper_method :current_user
  helper_method :render_404
  helper_method :event_started
  helper_method :event_started?
end
