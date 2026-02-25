class AdminEventsController < ApplicationController
  before_action :require_admin
  before_action :set_event, only: %i[show edit update destroy]

  def index
    @events = Event.includes(:volunteer_assignments).order(:event_date, :start_time)
  end

  def show
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)

    if @event.save
      @event.refresh_capacity_status!
      redirect_to admin_event_path(@event), notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      @event.refresh_capacity_status!
      redirect_to admin_event_path(@event), notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!
    redirect_to admin_events_path, notice: "Event was successfully deleted.", status: :see_other
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :location, :event_date, :start_time, :end_time, :required_volunteer_count, :status)
  end
end
