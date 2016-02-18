class SessionsController < ApplicationController
  include CurrentUserHelper

  # props to https://www.natashatherobot.com/rails-omniauth-github-tutorial/
  def create
    if user = Person.for_auth(request.env["omniauth.auth"])
      log_in_as(user)
      redirect_to root_url, flash: { success: "You are signed in" }
    else
      redirect_to login_url, flash: { error: "Unable to log in" }
    end
  end

  def destroy
    log_out
    redirect_to root_url, flash: { success: "You are signed out" }
  end
end
