class PeopleController < ApplicationController

  before_filter :require_profile_owner, except: [:index, :show]

  def index
    render partial: 'recent', locals: {
      people: Person.recent(10, scroll_continuation: params[:scroll_cont]) }
  end

  def show
  end

  def edit
  end

  def update
    if person.update(person_params)
      redirect_to person, flash: { success: 'Person updated' }
    else
      render :edit
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
    params[:person].permit(:name, :email, :url)
  end

end
