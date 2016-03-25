class SessionsController < ApplicationController
  include CurrentUserHelper

  # props to https://www.natashatherobot.com/rails-omniauth-github-tutorial/
  def create
    auth = request.env["omniauth.auth"]
    if user = Person.for_auth(auth)
      log_in_as(user)
      session["#{auth.provider}_token"] = auth.credentials.token

      redirect_to pluck_login_redirect_url, flash: { success: "You are logged in" }
    else
      redirect_to login_url, flash: { error: "Unable to log in" }
    end
  end

  def create_failed
    strategy = (params[:strategy] || "unknown").to_s.capitalize
    message = if params[:message]
      ": #{params[:message]}"
    end
    redirect_to login_url, flash: { error: "Internal #{strategy} authentication error#{message}" }
  end

  def destroy
    log_out
    redirect_to root_url, flash: { success: "You are logged out" }
  end
end
