class PeopleController < ApplicationController
  before_action :find_person, except: [:index, :new]

  def index
    render partial: 'recent', locals: {
      people: recent_people(before: Person.find(params[:before]), limit: 10) }
  end

  def show
  end

  def new
    @person = Person.new
  end

  def edit
  end

  def update
    if @person.update(person_params)
      redirect_to @person, notice: 'Person updated'
    else
      render :edit
    end
  end

private

  def find_person
    @person = Person.find(params[:id])
  end

  def person_params
    params[:person].permit(:name, :email, :url)
  end
end
