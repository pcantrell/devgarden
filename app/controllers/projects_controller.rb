require "github_api"

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
      redirect_to edit_project_tab_path('graphics')
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
      tag_ids: [], requested_role_ids: [])
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
    github = Octokit::Client.new(access_token: session[:github_token])

    Project.transaction do
      project.github_repos.each do |repo|
        repo_info = github.repository(repo)
        project.name    ||= repo_info.name.capitalize
        project.tagline ||= repo_info.description
        project.url     ||= repo_info.homepage

        github.contributors(repo).each do |contributor|
          person = Person.find_by(github_user: contributor.login) || begin
            Person.create_from_github_profile(
              github.user(contributor.login))
          end
          project.participations.new(person: person) if person
        end

        lang_tag_category = TagCategory.find_by(key: 'language')
        github.languages(repo).to_hash.keys.each do |lang|
          project.tags << lang_tag_category.find_or_create_tag!(lang)
        end
      end
    end

    if project.save
      render :edit
    else
      render :new
    end
  end

end
