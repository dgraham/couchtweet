# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :load_user

  private

  def load_user
    @current_user = User.get(session[:user_id]) if session[:user_id]
    reset_session if session[:user_id] && !@current_user
  end

  def authenticate
    redirect_to new_session_path unless session[:user_id]
  end

end
