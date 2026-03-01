require "test_helper"

class VolunteerSignupAndHistoryTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer = volunteers(:one)
  end

  test "logged in volunteer is redirected away from signup page" do
    post login_path, params: { login: { username: @volunteer.username, password: @volunteer.password, account_type: "volunteer" } }

    get signup_path

    assert_redirected_to volunteer_home_path
  end

  test "history only shows hours for completed events" do
    post login_path, params: { login: { username: @volunteer.username, password: @volunteer.password, account_type: "volunteer" } }

    completed_event = Event.create!(
      title: "Completed History Event",
      description: "Desc",
      location: "Location",
      event_date: Date.today,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00"),
      required_volunteer_count: 5,
      status: :completed
    )

    open_event = Event.create!(
      title: "Open History Event",
      description: "Desc",
      location: "Location",
      event_date: Date.today,
      start_time: Time.zone.parse("12:00"),
      end_time: Time.zone.parse("14:00"),
      required_volunteer_count: 5,
      status: :open
    )

    VolunteerAssignment.create!(volunteer: @volunteer, event: completed_event, status: :approved, hours_worked: 3.0)
    VolunteerAssignment.create!(volunteer: @volunteer, event: open_event, status: :approved, hours_worked: 4.0)

    get volunteer_history_path

    assert_response :success
    assert_includes @response.body, "Completed History Event"
    assert_not_includes @response.body, "Open History Event"
  end

  test "signup accepts a valid email address" do
    assert_difference("Volunteer.count", 1) do
      post signup_path, params: {
        volunteer: {
          username: "new_signup_user",
          password: "password",
          password_confirmation: "password",
          full_name: "New Signup User",
          email: "new_signup_user@example.com"
        }
      }
    end

    assert_redirected_to volunteer_home_path
  end

  test "signup rejects mismatched password confirmation" do
    assert_no_difference("Volunteer.count") do
      post signup_path, params: {
        volunteer: {
          username: "bad_signup_user",
          password: "password",
          password_confirmation: "not-the-same",
          full_name: "Bad Signup User",
          email: "bad_signup_user@example.com"
        }
      }
    end

    assert_response :unprocessable_entity
    assert_includes @response.body, "Password confirmation doesn&#39;t match password"
  end
end
