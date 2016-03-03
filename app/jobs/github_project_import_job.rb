require "github_api"

class GithubProjectImportJob < ApplicationJob
  queue_as :default

  def perform(opts = {})
    @project = Project.new(scm_urls: opts[:scm_urls])

    @github = Octokit::Client.new(access_token: opts[:github_token])

    project.github_repos.each do |repo|
      show_message "Importing #{repo}…"
      import_info(repo)
      import_contributors(repo, opts[:requesting_user])
      import_languages(repo)
    end

    project.save!

    {
      redirect_to: Rails.application.routes.url_helpers.edit_project_path(project),
      flash: {
        success: "Project imported."
      }
    }
  end

private

  attr_reader :project
  attr_reader :github

  def import_info(repo)
    repo_info = github.repository(repo)
    project.name    ||= repo_info.name.capitalize
    project.tagline ||= repo_info.description
    project.url     ||= repo_info.homepage
  end

  def import_contributors(repo, requesting_user)
    github.contributors(repo).each do |contributor|

      #! Locking not strictly safe here, could result in dup users in high-traffic env
      person = Person.transaction do
        Person.find_by(github_user: contributor.login) ||
        Person.create_from_github_profile(
          github.user(contributor.login))
      end
      project.participations.new(person: person, admin: person == requesting_user) if person
    end
  end

  def import_languages(repo)
    github.languages(repo).to_hash.keys.each do |lang|
      project.tags << language_tags.find_or_create_tag!(lang)
    end
  end

  def language_tags
    @language_tags ||= TagCategory.find_by(key: 'language')
  end
end
