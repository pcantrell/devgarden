class ProjectsController < ApplicationController

  before_filter :require_project_admin, except: [:index, :show, :new, :create]
  before_filter :require_login, except: [:index, :show]

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
    @project = Project.new(project_params)
    @project.participations.new(person: current_user, admin: true)

    if project.save
      redirect_to @project, flash: { success: 'Project created' }
    else
      render :new
    end
  end

  def update
    if project.update(project_params)
      redirect_to project, flash: { success: 'Project updated' }
    else
      render :edit
    end
  end

private

  def require_project_admin
    unless project.admins_include?(current_user)
      redirect_to login_path, flash: { error: "You must log in as an admin of #{project.name} in order to edit it." }
    end
  end

  def project
    @project ||= Project.find(params[:id])
  end
  helper_method :project

  def project_params
    params[:project].permit(:name, :tagline, :url, :scm_urls_as_text)
  end

end
