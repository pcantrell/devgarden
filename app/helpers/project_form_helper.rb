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
end
