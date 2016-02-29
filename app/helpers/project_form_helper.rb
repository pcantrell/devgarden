module ProjectFormHelper
  def project_form(tab_name, autosave: false, &block)
    opts = {
      remote: autosave,
      html: {
        id: "project-#{tab_name}-form",
        class: ('autosave' if autosave)
      }
    }
    semantic_form_for(project, **opts) do |f|
      capture do
        concat hidden_field_tag(:selected_tab, tab_name)
        yield f
      end
    end
  end

  def labeled_roles_for_category(category)
    category.roles.shuffle.map do |role|
      [role.person_name, role.id]
    end
  end
end
