class SessionsController < ApplicationController
  include CurrentUserHelper

  # props to https://www.natashatherobot.com/rails-omniauth-github-tutorial/
  def create
    auth = request.env["omniauth.auth"]
    if user = Person.for_auth(auth)
      log_in_as(user)
      session["#{auth.provider}_token"] = auth.credentials.token
      redirect_to edit_person_path(current_user), flash: { success: "You are signed in" }
    else
      redirect_to login_url, flash: { error: "Unable to log in" }
    end
  end

  def destroy
    log_out
    redirect_to root_url, flash: { success: "You are signed out" }
  end
end
