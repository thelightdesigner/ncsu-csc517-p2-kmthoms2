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
    assert @event.reload.full?
  end

  test "admin can remove completed assignment with logged hours" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    completed_event = Event.create!(
      title: "Completed Assignment Removal Event",
      description: "Desc",
      location: "Location",
      event_date: Date.new(2026, 2, 20),
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00"),
      required_volunteer_count: 5,
      status: :completed
    )

    assignment = VolunteerAssignment.create!(
      volunteer: @volunteer,
      event: completed_event,
      status: :completed,
      hours_worked: 2.5
    )

    assert_difference("VolunteerAssignment.count", -1) do
      delete admin_volunteer_assignment_path(assignment)
    end

    assert_redirected_to admin_volunteer_assignments_path
  end

  test "removing an approved assignment reopens a full event" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    assignment = VolunteerAssignment.create!(volunteer: @volunteer, event: @event, status: :approved)
    @event.reload
    assert @event.full?

    assert_difference("VolunteerAssignment.count", -1) do
      delete admin_volunteer_assignment_path(assignment)
    end

    assert_redirected_to admin_volunteer_assignments_path
    assert @event.reload.open?
  end
end
