class ProjectsController < ApplicationController

  def index
    render partial: 'recent', locals: {
      projects: Project.recent(10, scroll_continuation: params[:scroll_cont]) }
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    project = Project.new(project_params)

    if project.save
      redirect_to project, notice: 'Project created'
    else
      render :new
    end
  end

  def update
    if project.update(project_params)
      redirect_to project, notice: 'Project updated'
    else
      render :edit
    end
  end

private

  def project
    @project ||= Project.find(params[:id])
  end
  helper_method :project

  def project_params
    params[:project].permit(:name, :url, :scm_urls_as_text)
  end
end
