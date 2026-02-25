class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_volunteer, :current_admin, :volunteer_logged_in?, :admin_logged_in?

  private

  def current_volunteer
    @current_volunteer ||= Volunteer.find_by(id: session[:volunteer_id])
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def volunteer_logged_in?
    current_volunteer.present?
  end

  def admin_logged_in?
    current_admin.present?
  end

  def require_volunteer
    return if volunteer_logged_in?

    redirect_to login_path, alert: "Please log in as a volunteer to continue."
  end

  def require_admin
    return if admin_logged_in?

    redirect_to login_path, alert: "Please log in as an admin to continue."
  end

  def clear_session
    session.delete(:volunteer_id)
    session.delete(:admin_id)
  end
end
