class LoginsController < ApplicationController
  def show
    return redirect_to volunteer_home_path if volunteer_logged_in?
    return redirect_to admin_home_path if admin_logged_in?
  end

  def create
    clear_session

    if login_params[:account_type] == "admin"
      authenticate_admin
    else
      authenticate_volunteer
    end
  end

  def destroy
    clear_session
    redirect_to root_path, notice: "Logged out successfully."
  end

  private

  def authenticate_volunteer
    volunteer = Volunteer.find_by(username: login_params[:username], password: login_params[:password])

    if volunteer
      session[:volunteer_id] = volunteer.id
      redirect_to volunteer_home_path, notice: "Logged in successfully."
    else
      invalid_login
    end
  end

  def authenticate_admin
    admin = Admin.first

    if admin&.username == login_params[:username] && admin&.password == login_params[:password]
      session[:admin_id] = admin.id
      redirect_to admin_home_path, notice: "Admin logged in successfully."
    else
      invalid_login
    end
  end

  def invalid_login
    flash.now[:alert] = "Invalid credentials."
    render :show, status: :unprocessable_entity
  end

  def login_params
    params.require(:login).permit(:username, :password, :account_type)
  end
end
