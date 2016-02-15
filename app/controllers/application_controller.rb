class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper

  def body_classes
    [
      controller_name,
      action_name,
      ("#{controller_name.singularize}-#{params[:id]}" if params[:id])
    ].compact
  end
  helper_method :body_classes
end
