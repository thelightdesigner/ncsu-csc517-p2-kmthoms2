class AdminVolunteersController < ApplicationController
  before_action :require_admin
  before_action :set_volunteer, only: %i[show edit update destroy]

  def index
    @volunteers = Volunteer.order(:full_name)
  end

  def show
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      redirect_to admin_volunteer_path(@volunteer), notice: "Volunteer was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @volunteer.update(volunteer_params)
      redirect_to admin_volunteer_path(@volunteer), notice: "Volunteer was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @volunteer.destroy!
    redirect_to admin_volunteers_path, notice: "Volunteer was successfully deleted.", status: :see_other
  end

  private

  def set_volunteer
    @volunteer = Volunteer.find(params[:id])
  end

  def volunteer_params
    params.require(:volunteer).permit(:username, :password, :full_name, :email, :phone_number, :address, :skills, :interests)
  end
end
