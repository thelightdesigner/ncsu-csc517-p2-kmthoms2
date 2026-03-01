require "test_helper"

class AdminEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
    @event = events(:one)
    @event.update!(
      required_volunteer_count: 2,
      status: :open,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00")
    )
  end

  test "admin can mark event completed from quick action" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    patch complete_admin_event_path(@event)

    assert_redirected_to admin_events_path
    assert @event.reload.completed?
  end
end
