class TagsController < ApplicationController

  before_action :require_site_admin, except: [:index, :show]

  def show
  end

  def new
    @tag = Tag.new
    render :edit
  end

  def edit
  end

  def create
    @tag = Tag.new(tag_params)

    success = notify_admin_of_changes(current_tag) do
      current_tag.save
    end

    if success
      flash[:success] = 'Tag created'
      redirect_to current_tag
    else
      render :edit
    end
  end

  def update
    success = notify_admin_of_changes(current_tag) do
      current_tag.update(tag_params)
    end

    if success
      flash[:success] = 'Tag updated'
      redirect_to current_tag
    else
      render :edit
    end
  end

private

  def tag_params
    params.require(:tag).permit(:name, :short_name, :category_id, :url, :description, :visible)
  end

  # Called “current_tag” because Rails alreay defines a helper method named “tag”
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
