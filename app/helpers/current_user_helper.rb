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

  def require_login
    unless logged_in?
      redirect_to login_path, flash: { error: "You must log in to #{action_name_as_verb} #{controller_name}." }
    end
  end

  def action_name_as_verb
    case action_name
      when "new"           then "create"
      when "index", "show" then "view"
      else action_name
    end
  end

end
