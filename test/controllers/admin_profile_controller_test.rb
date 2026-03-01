require "test_helper"

class AdminProfileControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
  end

  test "admin cannot change password from profile update" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    original_password = @admin.password

    patch admin_profile_path, params: {
      admin: {
        full_name: "Updated Name",
        email: "updated_admin@example.com",
        password: "new-secret"
      }
    }

    assert_redirected_to admin_profile_path
    @admin.reload
    assert_equal original_password, @admin.password
    assert_equal "Updated Name", @admin.full_name
    assert_equal "updated_admin@example.com", @admin.email
  end
end
