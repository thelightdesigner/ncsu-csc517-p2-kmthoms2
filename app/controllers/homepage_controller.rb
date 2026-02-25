class HomepageController < ApplicationController
  def home
    return redirect_to volunteer_home_path if volunteer_logged_in?
    return redirect_to admin_home_path if admin_logged_in?
  end
end
