class SessionsController < ApplicationController
  def new
  end

  def create
    name, password = params.values_at(:username, :password)
    missing = [name, password].any? {|v| v.blank? }
    redirect_to new_session_path and return if missing
    user = User.get(name)
    if user && user.authenticate(password)
      session[:user_id] = user.id
      redirect_to root_path
    else
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
