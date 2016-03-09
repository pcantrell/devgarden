class ProjectsController < ApplicationController

  before_action :require_project_admin, except: [:index, :show, :new, :create]
  before_action :require_login, except: [:index, :show]
  before_action :remove_duplicate_params

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
    return populate_from_github if params[:project][:populate_from_github]

    @project.participations.new(person: current_user, admin: true)

    if project.save
      flash[:success] = 'Project created'
      redirect_to edit_project_tab_path('icon')
    else
      render :new
    end
  end

  def update
    success = project.update(project_params)

    respond_to do |format|
      format.html do
        if success
          tab = params[:selected_tab] || ""
          flash[:success] = "Project #{tab.downcase} updated"
          redirect_to edit_project_tab_path(tab)
        else
          render :edit
        end
      end
      format.js do
        head(success ? 200 : 400)
      end
      format.json do
        render json: { success: success }
      end
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
    params[:project].permit(
      :name, :tagline, :description, :url, :scm_urls_as_text, :icon, :icon_cache,
      theme: [:primary_hue, :highlight_hue], tag_ids: [], requested_role_ids: [])
  end

  def edit_project_tab_path(tab_name)
    edit_project_path(project, anchor: tab_name)
  end

  # For unknown reasons, remote: true causes tag and role request checkboxes to
  # show up multiple times in the submitted array. Rails bug?
  def remove_duplicate_params
    [:tag_ids, :requested_role_ids].each do |key|
      if params[:project] && params[:project][key]
        params[:project][key].uniq!
      end
    end
  end

  def populate_from_github

    # Validate URLs using dumming project
    unless project.github_repos.any?
      project.errors.add(:scm_urls_as_text, "Please enter at least one Github repository.")
      return render :new
    end

    # Now discard dummy and let background job create real project
    
    job_report = JobReport.create!(
      owner: current_user,
      message: "Importing project…")

    GithubProjectImportJob.perform_later(
      scm_urls: project.scm_urls,
      github_token: session[:github_token],
      requesting_user: current_user,
      job_report: job_report)
    Que.wake!

    redirect_to job_report
  end

  def participants_json
    project.participations.includes(:person).map do |p|
      {
        id: p.id,
        full_name: p.person.full_name,
        avatar_url: p.person.avatar_url,
        admin: p.admin
      }
    end.to_json
  end
  helper_method :participants_json

end
