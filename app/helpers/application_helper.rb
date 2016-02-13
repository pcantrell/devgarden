require "svg_path"

module ApplicationHelper

  def roles_by_category
    RoleCategory.includes(:roles).shuffle
  end

  def span_tag(css_class, text)
    content_tag(:span, text, class: css_class)
  end

end
