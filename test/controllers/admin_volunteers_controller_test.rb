require "test_helper"

class AdminVolunteersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
    @volunteer = volunteers(:one)
  end

  test "admin can create volunteer" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    assert_difference("Volunteer.count", 1) do
      post admin_volunteers_path, params: {
        volunteer: {
          username: "created_by_admin",
          password: "password",
          full_name: "Created Volunteer",
          email: "created@example.com",
          phone_number: "1234567890"
        }
      }
    end

    assert_redirected_to admin_volunteer_path(Volunteer.last)
  end

  test "admin can destroy volunteer" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    assert_difference("Volunteer.count", -1) do
      delete admin_volunteer_path(@volunteer)
    end

    assert_redirected_to admin_volunteers_path
  end
end
