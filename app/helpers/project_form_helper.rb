module ProjectFormHelper
  def project_form(tab_name, &block)
    semantic_form_for(project, html: { id: "project-#{tab_name}-form" }) do |f|
      yield f
    end
  end
end
