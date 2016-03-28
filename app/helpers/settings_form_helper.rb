module SettingsFormHelper

  def settings_form_for(model, tab_name, autosave: true, &block)
    autosave = false if model.new_record?

    opts = {
      remote: autosave,
      html: {
        id: "#{model.class.name.dasherize.downcase}-#{tab_name}",
        class: ('autosave' if autosave)
      }
    }
    semantic_form_for(model, **opts) do |f|
      capture do
        concat f.semantic_errors
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
