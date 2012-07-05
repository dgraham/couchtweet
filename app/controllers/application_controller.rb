class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :load_user

  attr_reader :current_user

  private

  def load_user
    @current_user = User.get(session[:user_id]) if session[:user_id]
    reset_session if session[:user_id] && !@current_user
  end

  def authenticate
    redirect_to signin_path unless session[:user_id]
  end
end
