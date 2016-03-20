class AdminNotifications < ApplicationMailer
  default from: "pcantrel@macalester.edu"
  layout 'admin_notifications'

  def user_made_changes(user, model, action, changed_attrs = {})
    @user_name = user.name
    @action = action.sub(/e?$/, 'ed')
    @model = model
    @changed_attrs = changed_attrs

    mail to: Person.where(site_admin: true).map(&:email),
         subject: "[devgarden] #{@user_name} made changes"
  end

private

  def model_name(model)
    model.try(:name)&.presence || model.to_s
  end
  helper_method :model_name

end
