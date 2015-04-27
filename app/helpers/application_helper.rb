module ApplicationHelper
  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end
end
