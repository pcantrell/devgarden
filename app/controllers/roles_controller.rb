class RolesController < ApplicationController
  def index
  end

  def show
  end

private

  def role
    @role ||= Role.find(params[:id])
  end
  helper_method :role

end
