module SettingsFormHelper

  def settings_form_for(model, tab_name, autosave: true, last_tab: false, &block)
    autosave = false if model.new_record?

    opts = {
      remote: autosave,
      html: {
        id: "#{model.class.name.dasherize.downcase}-#{tab_name}",
        class: [
          'warn-unsaved',
          ('autosave' if autosave)
        ].compact.join(' ')
      }
    }
    semantic_form_for(model, **opts) do |f|
      capture do
        concat f.semantic_errors
        concat hidden_field_tag(:selected_tab, tab_name)

        yield f

        haml_tag(:div, class: 'actions') do
          if model.new_record?
            concat f.save_button
          elsif params[:initial_setup]
            concat f.save_button(
              title_for_existing_record: last_tab ? 'Done' : 'Next',
              html: { class: 'next-tab' })
          end
        end
      end
    end
  end

  def labeled_roles_for_category(category)
    category.roles.shuffle.map do |role|
      [role.person_name, role.id]
    end
  end

end
