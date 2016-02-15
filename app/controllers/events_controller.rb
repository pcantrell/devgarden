class EventsController < ApplicationController
  def index
  end

  def show
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
