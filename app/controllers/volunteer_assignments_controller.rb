class VolunteerAssignmentsController < ApplicationController
  before_action :require_volunteer
  before_action :set_owned_assignment, only: :destroy

  def index
    @volunteer_assignments = current_volunteer.volunteer_assignments.includes(:event).order(created_at: :desc)
  end

  def create
    event = Event.find(params[:event_id])

    if current_volunteer.volunteer_assignments.exists?(event_id: event.id)
      return redirect_to events_path, alert: "You already signed up for this event."
    end

    unless event.open?
      return redirect_to events_path, alert: "This event is not open for sign-up."
    end

    assignment = current_volunteer.volunteer_assignments.build(event: event, status: :pending)

    if assignment.save
      redirect_to events_path, notice: "Sign-up submitted and pending admin approval."
    else
      redirect_to events_path, alert: assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @volunteer_assignment.destroy!
    redirect_to assigned_events_path, notice: "You have withdrawn from the event."
  end

  private

  def set_owned_assignment
    @volunteer_assignment = current_volunteer.volunteer_assignments.find(params[:id])
  end
end
