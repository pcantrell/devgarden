class TagsController < ApplicationController
  def index
  end

  def show
  end

private

  def current_tag
    @tag ||= Tag.find(params[:id])
  end
  helper_method :current_tag

  def project_list_heading
    if current_tag.category.key == 'family'
      "Projects"
    else
      "Used by"
    end
  end
  helper_method :project_list_heading

end
