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
      yield f
    end
  end
end
