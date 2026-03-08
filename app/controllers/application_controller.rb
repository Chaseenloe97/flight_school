class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.first || User.create!(
      email: "owner@flightschool.com",
      password: "password",
      password_confirmation: "password"
    )
  end

  def logged_in?
    true
  end

  def require_login
    # No-op: authentication disabled
  end
end
