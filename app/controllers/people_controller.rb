class PeopleController < ApplicationController

  before_action :require_profile_owner, except: [:index, :show]

  def index
    respond_to do |format|

      format.html do
        if params[:scroll_cont]
          render partial: 'recent', locals: {
            people: Person.visible.recent(10, scroll_continuation: params[:scroll_cont]) }
        else
          redirect_to root_path
        end
      end

      format.json do
        render(json:
          Person
            .name_search(params[:q])
            .limit(32)
            .map do |p|
              {
                id: p.id,
                name: p.name,
                avatar_url: p.avatar_url,
              }
            end
        )
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    success = notify_admin_of_changes(person) do
      person.update(person_params)
    end

    respond_to do |format|
      format.html do
        if success
          tab = params[:selected_tab] || ""
          flash[:success] = "Profile #{tab.downcase} updated"
          redirect_to edit_person_path(person, anchor: tab)
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

  def require_profile_owner
    unless can_edit?(person)
      redirect_to login_path, flash: { error: "You must log in as #{person.name} in order to edit their profile." }
    end
  end

  def can_edit?(person)
    current_user&.site_admin? || person == current_user
  end
  helper_method :can_edit?

  def person
    @person ||= Person.find(params[:id])
  end
  helper_method :person

  def person_params
    params[:person].permit(:full_name, :email, :urls_as_text, :class_year, :department, offered_role_ids: [])
  end

  def project_groups
    @project_groups ||=
      person.participations.with_visible_project.group_by do |participation|
        if participation.admin?
          :admin
        else
          :participant
        end
      end.map do |group, participations|
        [group, participations.map(&:project)]
      end
  end
  helper_method :project_groups

end
