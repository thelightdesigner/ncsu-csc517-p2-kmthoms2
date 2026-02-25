class VolunteersController < ApplicationController
  before_action :require_volunteer, except: %i[new create]

  def home
    @volunteer = current_volunteer
  end

  def assigned_events
    @assignments = current_volunteer.volunteer_assignments.includes(:event).order(created_at: :desc)
  end

  def history
    @assignments_with_hours = current_volunteer.volunteer_assignments.includes(:event).where.not(hours_worked: nil).order(date_logged: :desc)
    @total_hours = current_volunteer.total_logged_hours
  end

  def show
    @volunteer = current_volunteer
  end

  def new
    @volunteer = Volunteer.new
  end

  def edit
    @volunteer = current_volunteer
  end

  def create
    @volunteer = Volunteer.new(signup_params)

    if @volunteer.save
      clear_session
      session[:volunteer_id] = @volunteer.id
      redirect_to volunteer_home_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @volunteer = current_volunteer

    if @volunteer.update(profile_params)
      redirect_to volunteer_profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_volunteer.destroy!
    clear_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  private

  def signup_params
    params.require(:volunteer).permit(:username, :password, :full_name, :email, :phone_number, :address, :skills, :interests)
  end

  def profile_params
    params.require(:volunteer).permit(:password, :full_name, :email, :phone_number, :address, :skills, :interests)
  end
end
