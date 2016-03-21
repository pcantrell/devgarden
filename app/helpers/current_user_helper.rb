module CurrentUserHelper

  def log_in_as(person)
    handle_first_login(person) if person.last_login_at.blank?
    person.update!(last_login_at: Time.now)

    session[:user_id] = person.id
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
    session[:user_id] ||= ENV['fake_login']&.to_i if Rails.env.development?
    !!session[:user_id]
  end

  def require_login
    unless logged_in?
      redirect_to login_path, flash: { error: "You must log in to #{action_name_as_verb} #{controller_name}." }
    end
  end

  def require_site_admin
    unless current_user&.site_admin?
      redirect_to login_path, flash: { error: "You must log in as a site admininistrator to #{action_name_as_verb} #{controller_name}." }
    end
  end

  def action_name_as_verb
    case action_name
      when "new"           then "create"
      when "index", "show" then "view"
      else action_name
    end
  end

private

  def handle_first_login(person)
    AdminNotifications
      .user_made_changes(person, person, "create")
      .deliver_later

    SubscribeToMailingListJob
      .set(wait: 5.seconds)   # so they have time to change their email
      .perform_later(person)
  end

end
