module CurrentUserHelper

  def log_in_as(user)
    session[:user_id] = user.id
  end

  def log_out
    session[:user_id] = nil
  end

  def current_user
    if session[:user_id]
      @current_user ||= Person.find(session[:user_id])
    end
  end

  def logged_in?
    !!session[:user_id]
  end

end
