class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]
    if !@current_user.nil?
      @current_user.update_column(:last_login, Time.now)
    end
    return @current_user
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
    if !is_admin? && Time.now < Rails.application.config.event_start
      flash[:danger] = "Du kan ikke gjør dette enda, LANet har ikke startet :'("
      redirect_to root_path
    end
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
