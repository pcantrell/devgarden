module ApplicationHelper
  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end

  def summary_style(model)
    "background: hsl(#{rand(360)}, 75%, 40%);"
  end
end
