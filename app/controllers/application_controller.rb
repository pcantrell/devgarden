class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :wrap_in_transaction

  include ApplicationHelper

  def body_classes
    [
      "#{controller_name.dasherize}-controller",
      "#{action_name}-action",
      ("#{controller_name.singularize}-#{params[:id]}" if params[:id]),
      ("logged-in" if logged_in?),
      ("ie" if request.user_agent =~ /MSIE|Trident/)
    ].compact
  end
  helper_method :body_classes

protected

  def notify_admin_of_changes(model)
    old_values = model.notification_attributes

    success = yield

    if success
      changed_attrs = model.notification_attributes.map do |key, new_value|
        old_value = old_values[key]
        if old_value != new_value
          {
            name: key.to_s,
            old_value: old_value.to_s,
            new_value: new_value.to_s
          }
        end
      end.compact

      if changed_attrs.any?
        AdminNotifications
          .user_made_changes(current_user, model, action_name, changed_attrs)
          .deliver_later
      end
    end

    success
  end

private

  def wrap_in_transaction(&block)
    ApplicationRecord.transaction(&block)
  end

end
