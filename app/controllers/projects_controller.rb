class ProjectsController < ApplicationController

  before_action :require_project_admin, except: [:index, :show, :new, :create]
  before_action :require_login, except: [:index, :show]

  def index
    if params[:scroll_cont]
      render partial: 'recent', locals: {
        projects: Project.recent(10, scroll_continuation: params[:scroll_cont]) }
    else
      redirect_to root_path
    end
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

    @duplicate_imports = project.scm_urls.map do |url|
      if duplicate = Project.with_scm_url(url).first
        OpenStruct.new(
          repo: url,
          project: duplicate)
      end
    end.compact
    if @duplicate_imports.any?
      return render :new
    end

    return populate_from_github if params[:project][:populate_from_github]

    @project.participations.new(person: current_user, admin: true)

    success = notify_admin_of_changes(project) do
      project.save
    end

    if success
      flash[:success] = 'Project created'
      redirect_to edit_project_tab_path('icon')
    else
      render :new
    end
  end

  def update
    success = notify_admin_of_changes(project) do
      begin
        Project.transaction do
          if project_params[:participations_attributes]
            project.participations.destroy_all
          end
          
          project.update!(project_params)
          project.touch  # Because tag & role req updates don’t touch project, despite touch: true on assocations

          unless can_edit?(project)
            raise "Cannot remove self as project admin"
          end
        end
        true
      rescue ActiveRecord::RecordInvalid
        false
      end
    end

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
    unless can_edit?(project)
      redirect_to login_path, flash: { error: "You must log in as an admin of #{project.name} in order to edit it." }
    end
  end

  def can_edit?(project)
    current_user&.site_admin? || project.admins_include?(current_user)
  end
  helper_method :can_edit?

  def project
    @project ||= Project.find(params[:id])
  end
  helper_method :project

  def duplicate_imports
    @duplicate_imports ||= []
  end
  helper_method :duplicate_imports

  def project_params
    params[:project].permit(
      :name, :tagline, :description, :url, :scm_urls_as_text, :icon, :icon_cache,
      theme: [:primary_hue, :highlight_hue],
      participations_attributes: [:person_id, :admin],
      tag_ids: [], requested_role_ids: [])
  end

  def edit_project_tab_path(tab_name)
    edit_project_path(project, anchor: tab_name)
  end

  def populate_from_github

    # Validate URLs using dumming project
    unless project.github_repos.any?
      project.errors.add(:scm_urls_as_text, "Please enter at least one Github repository.")
      return render :new
    end

    # Now discard dummy and let background job create real project
    
    JobReport.transaction do
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
  end

  def participants_json
    project.participations.includes(:person).map do |p|
      {
        id: p.person.id,
        name: p.person.name,
        avatar_url: p.person.avatar_url,
        admin: p.admin,
        self: p.person == current_user
      }
    end.to_json
  end
  helper_method :participants_json

end
