class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :wrap_in_transaction

  include ApplicationHelper

  def body_classes
    [
      "#{controller_name}-controller",
      "#{action_name}-action",
      ("#{controller_name.singularize}-#{params[:id]}" if params[:id]),
      ("logged-in" if logged_in?)
    ].compact
  end
  helper_method :body_classes

private

  def wrap_in_transaction(&block)
    ApplicationRecord.transaction(&block)
  end

end
