require "test_helper"

class AdminVolunteerAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
    @volunteer = volunteers(:one)
    @event = events(:one)
    @event.update!(
      required_volunteer_count: 5,
      status: :open,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00")
    )
  end

  test "admin can create assignment" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    assert_difference("VolunteerAssignment.count", 1) do
      post admin_volunteer_assignments_path, params: {
        volunteer_assignment: {
          volunteer_id: @volunteer.id,
          event_id: @event.id,
          status: "approved"
        }
      }
    end

    assert_redirected_to admin_volunteer_assignments_path
  end
end
