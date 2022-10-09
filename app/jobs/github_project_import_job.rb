require "github_api"

class GithubProjectImportJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(opts = {})
    raise "Missing GitHub access token (Are you not logged in?)" unless opts[:github_token]

    @project = Project.new(scm_urls: opts[:scm_urls])
    @requesting_user = opts[:requesting_user]

    @github = Octokit::Client.new(access_token: opts[:github_token])

    project.github_repos.each do |repo|
      show_message "Importing #{repo}…"
      import_info(repo)
      import_contributors(repo)
      import_languages(repo)
    end

    project.save!

    AdminNotifications
      .user_made_changes(@requesting_user, project, "import")
      .deliver_later

    {
      redirect_to: edit_project_path(project, anchor: :info, initial_setup: 1),
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
    unless repo_info.permissions.push || @requesting_user.site_admin?
      raise "You need to have push access to #{repo} on GitHub in order to import it."
    end
    project.name    ||= repo_info.name&.capitalize
    project.tagline ||= (repo_info.description || "")[0...Project::MAX_TAGLINE_LENGTH]
    project.url     ||= repo_info.homepage
  end

  def import_contributors(repo)
    github.contributors(repo).each do |contributor|
      person = person_for_github_contributor(contributor)
      project.participations.new(person: person, admin: person == @requesting_user) if person
    end
    
    unless project.participations.any? { |p| p.person == @requesting_user } || @requesting_user.site_admin?
      raise "You need to be a contributor to #{repo} on GitHub in order to import it."
    end
  end

  def person_for_github_contributor(contributor)
    #! Locking not strictly safe here, could result in dup users in high-traffic env
    Person.transaction do
      if person = Person.find_by_github_user(contributor.login)
        return person
      end

      profile = github.user(contributor.login)
      person = Person.find_by_email(profile.email) ||
               Person.new

      person.github_user ||= profile.login
      person.full_name   ||= profile.name
      person.email       ||= profile.email
      person.urls = (
          person.urls + [
            profile.html_url,
            profile.blog
          ]
        ).compact.uniq
      person.save!

      person
    end
  end

  def import_languages(repo)
    languages = github.languages(repo).to_hash
    total_bytes = languages.values.sum
    languages.each do |lang, bytes|
      tag = language_tags.find_or_create_tag!(lang)  # Always create language tag, but...
      if bytes / total_bytes.to_f > 0.04             # ...don’t import it if barely used
        project.tags << tag
      end
    end
  end

  def language_tags
    @language_tags ||= TagCategory.find_by(key: 'language')
  end
end
