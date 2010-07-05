class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.get(params[:username])
    if user && !params[:password].blank? && user.password == hmac(params[:password], user.id)
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

  private

  def hmac(key, data)
    digest = OpenSSL::Digest::Digest.new("sha512")
    OpenSSL::HMAC.hexdigest(digest, key, data)
  end

end
