class EventsController < ApplicationController

  before_action :require_site_admin, except: [:index, :show]

  def index
  end

  def show
  end

  def new
    @event = Event.new
    render :edit
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    success = notify_admin_of_changes(event) do
      event.save
    end

    if success
      flash[:success] = 'Event created'
      redirect_to event
    else
      render :edit
    end
  end

  def update
    success = notify_admin_of_changes(event) do
      event.update(event_params)
    end

    if success
      flash[:success] = 'Event updated'
      redirect_to event
    else
      render :edit
    end
  end

private

  def event_params
    params[:event].permit(:title, :description)
  end

  def event
    @event ||= Event.find(params[:id])
  end
  helper_method :event
  
  def event_query_description
    "Upcoming Events"
  end
  helper_method :event_query_description

  def event_query(&block)
    upcoming_events(min_events: 10, including_all_within: 1.year, &block)
  end
  helper_method :event_query

end
