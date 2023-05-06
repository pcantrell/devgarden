require 'ostruct'

class AdminNotifications < ApplicationMailer
  default from: "pcantrel@macalester.edu"
  layout 'admin_notifications'

  def user_made_changes(user, model, action, changed_attrs = {})
    @user_name = user.name
    @action = action.sub(/e?$/, 'ed')
    @model = model
    @changed_attrs = changed_attrs

    mail to: site_admin_emails,
         subject: "[devgarden] #{@user_name} made changes",
         references: "<#{user.id}changes@devgarden>"
  end

  def calendar_import_had_problems(problems)
    @problems = problems

    mail to: site_admin_emails,
         subject: "[devgarden] Calendar import problems"
  end

  def self.soft_failure(message, **attrs)
    yield
  rescue => e
    AdminNotifications
      .generic_error(
        "WARNING: #{message}",
        attrs: attrs,
        error_message: e.inspect,
        backtrace: e.backtrace)
      .deliver_later
  end

  def generic_error(message, attrs: {}, error_message:, backtrace: nil)
    @message = message
    @attrs = attrs
    @error_message = error_message
    @backtrace = backtrace

    mail to: site_admin_emails,
         subject: "[devgarden] #{message}"
  end

private

  def model_name(model)
    model.try(:name)&.presence || model.to_s
  end
  helper_method :model_name

  def site_admin_emails
    Person.where(site_admin: true).map(&:email)
  end

end
