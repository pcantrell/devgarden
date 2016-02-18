class PeopleController < ApplicationController
  def index
    render partial: 'recent', locals: {
      people: Person.recent(10, scroll_continuation: params[:scroll_cont]) }
  end

  def show
  end

  def new
    @person = Person.new
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

  def person
    @person ||= Person.find(params[:id])
  end
  helper_method :person

  def person_params
    params[:person].permit(:name, :email, :url)
  end
end
