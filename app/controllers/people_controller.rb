class PeopleController < ApplicationController

  before_action :require_profile_owner, except: [:index, :show]

  def index
    respond_to do |format|

      format.html do
        if params[:scroll_cont]
          render partial: 'recent', locals: {
            people: Person.recent(10, scroll_continuation: params[:scroll_cont]) }
        else
          redirect_to root_path
        end
      end

      format.json do
        render json:
          Person
            .name_search(params[:q])
            .limit(32)
            .select(:id, :full_name, :avatar_url)
            .to_json
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    success = person.update(person_params)

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
    unless current_user == person
      redirect_to login_path, flash: { error: "You must log in as #{person.name} in order to edit their profile." }
    end
  end

  def person
    @person ||= Person.find(params[:id])
  end
  helper_method :person

  def person_params
    params[:person].permit(:name, :email, :urls_as_text, :class_year, :department, offered_role_ids: [])
  end

end
