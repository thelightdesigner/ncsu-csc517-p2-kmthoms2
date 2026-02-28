class AdminsController < ApplicationController
  before_action :require_admin

  def home
    @admin = current_admin
  end

  def show
    @admin = current_admin
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin

    if @admin.update(admin_profile_params)
      redirect_to admin_profile_path, notice: "Profile updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def admin_profile_params
    params.require(:admin).permit(:password, :full_name, :email)
  end
end
