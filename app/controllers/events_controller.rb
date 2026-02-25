class EventsController < ApplicationController
  before_action :require_volunteer
  before_action :set_event, only: :show

  def index
    @events = Event.includes(:volunteer_assignments).order(:event_date, :start_time)
    @my_assignment_event_ids = current_volunteer.volunteer_assignments.pluck(:event_id)
  end

  def show
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end
end
