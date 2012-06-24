class WelcomeController < ApplicationController
  before_filter :authenticate

  def index
    @user = current_user
    @tweets = current_user.timeline.all
  end
end
