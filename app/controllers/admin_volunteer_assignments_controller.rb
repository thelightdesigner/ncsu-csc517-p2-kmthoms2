class AdminVolunteerAssignmentsController < ApplicationController
  before_action :require_admin
  before_action :set_assignment, only: %i[edit update destroy approve complete]

  def index
    @volunteer_assignments = VolunteerAssignment.includes(:volunteer, :event).order(created_at: :desc)
  end

  def edit
  end

  def update
    if @assignment.update(hours_params)
      redirect_to admin_volunteer_assignments_path, notice: "Volunteer hours updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def approve
    if !@assignment.pending?
      return redirect_to admin_volunteer_assignments_path, alert: "Only pending assignments can be approved."
    end

    @assignment.event.with_lock do
      if @assignment.event.slots_available?
        @assignment.update!(status: :approved)
      else
        return redirect_to admin_volunteer_assignments_path, alert: "Cannot approve: event has no available slots."
      end
    end

    redirect_to admin_volunteer_assignments_path, notice: "Assignment approved."
  end

  def complete
    unless @assignment.approved?
      return redirect_to admin_volunteer_assignments_path, alert: "Only approved assignments can be marked completed."
    end

    if @assignment.update(status: :completed)
      redirect_to admin_volunteer_assignments_path, notice: "Assignment marked as completed."
    else
      redirect_to admin_volunteer_assignments_path, alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    @assignment.update!(status: :removed)
    @assignment.destroy!
    redirect_to admin_volunteer_assignments_path, notice: "Assignment removed from event."
  end

  private

  def set_assignment
    @assignment = VolunteerAssignment.find(params[:id])
  end

  def hours_params
    params.require(:volunteer_assignment).permit(:hours_worked, :date_logged)
  end
end
