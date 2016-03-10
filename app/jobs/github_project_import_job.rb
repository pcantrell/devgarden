require "github_api"

class GithubProjectImportJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers

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
      redirect_to: edit_project_path(project, anchor: :info),
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
    unless repo_info.permissions.push
      raise "You need to have push access to #{repo} on Github in order to import it."
    end
    project.name    ||= repo_info.name.capitalize
    project.tagline ||= repo_info.description[0...Project::MAX_TAGLINE_LENGTH]
    project.url     ||= repo_info.homepage
  end

  def import_contributors(repo, requesting_user)
    github.contributors(repo).each do |contributor|
      person = person_for_github_contributor(contributor)
      project.participations.new(person: person, admin: person == requesting_user) if person
    end
    unless project.participations.any? { |p| p.person == requesting_user }
      raise "You need to be a contributor to #{repo} on Github in order to import it."
    end
  end

  def person_for_github_contributor(contributor)
    #! Locking not strictly safe here, could result in dup users in high-traffic env
    Person.transaction do
      Person.find_by(github_user: contributor.login) || begin
        profile = github.user(contributor.login)
        Person.find_by(email: profile.email) ||
          Person.create(
            github_user: profile.login,
            full_name:   profile.name,
            email:       profile.email,
            urls:        ["https://github.com/#{profile.login}", profile.blog].compact)
      end
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
