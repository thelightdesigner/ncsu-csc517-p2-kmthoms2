require "test_helper"

class AdminAnalyticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = admins(:one)
    @volunteer = volunteers(:one)
  end

  test "admin can access analytics page" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    get admin_analytics_path

    assert_response :success
    assert_includes @response.body, "Volunteer Analytics"
  end

  test "volunteers cannot access analytics page" do
    post login_path, params: { login: { username: @volunteer.username, password: @volunteer.password, account_type: "volunteer" } }

    get admin_analytics_path

    assert_redirected_to login_path
  end

  test "analytics only include completed assignments and respect volunteer filter" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    analytics_volunteer = Volunteer.create!(
      username: "analytics_volunteer",
      password: "password",
      full_name: "Analytics Volunteer",
      email: "analytics_volunteer@example.com"
    )

    completed_event = Event.create!(
      title: "Analytics Completed Event",
      description: "Desc",
      location: "Location",
      event_date: Date.new(2026, 2, 15),
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00"),
      required_volunteer_count: 3,
      status: :completed
    )

    approved_only_event = Event.create!(
      title: "Analytics Approved Event",
      description: "Desc",
      location: "Location",
      event_date: Date.new(2026, 2, 16),
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00"),
      required_volunteer_count: 3,
      status: :completed
    )

    VolunteerAssignment.create!(volunteer: analytics_volunteer, event: completed_event, status: :completed, hours_worked: 3.0)
    VolunteerAssignment.create!(volunteer: analytics_volunteer, event: approved_only_event, status: :approved, hours_worked: 7.0)

    get admin_analytics_path, params: { volunteer_id: analytics_volunteer.id }

    assert_response :success
    assert_includes @response.body, "Analytics Volunteer"
    assert_includes @response.body, "Analytics Completed Event"
    assert_not_includes @response.body, "Analytics Approved Event"
    assert_includes @response.body, "3.00"
  end

  test "low participation includes volunteers with zero completed assignments" do
    post login_path, params: { login: { username: @admin.username, password: @admin.password, account_type: "admin" } }

    no_participation = Volunteer.create!(
      username: "no_participation_user",
      password: "password",
      full_name: "No Participation Volunteer",
      email: "no_participation@example.com"
    )

    get admin_analytics_path, params: { volunteer_id: no_participation.id }

    assert_response :success
    assert_includes @response.body, "No Participation Volunteer"
  end
end
