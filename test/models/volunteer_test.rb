require "test_helper"

class VolunteerTest < ActiveSupport::TestCase
  test "accepts localhost email addresses" do
    volunteer = Volunteer.new(
      username: "localhost_user",
      password: "password",
      full_name: "Local Host",
      email: "admin@localhost"
    )

    assert volunteer.valid?
  end

  test "rejects invalid email addresses" do
    volunteer = Volunteer.new(
      username: "bad_email_user",
      password: "password",
      full_name: "Bad Email",
      email: "not-an-email"
    )

    assert_not volunteer.valid?
    assert_includes volunteer.errors[:email], "is invalid"
  end

  test "rejects phone numbers with non-digits" do
    volunteer = Volunteer.new(
      username: "phone_user",
      password: "password",
      full_name: "Phone User",
      email: "phone@example.com",
      phone_number: "123-456"
    )

    assert_not volunteer.valid?
    assert_includes volunteer.errors[:phone_number], "must contain only digits"
  end

  test "total logged hours only includes completed events" do
    volunteer = Volunteer.create!(
      username: "hours_user",
      password: "password",
      full_name: "Hours User",
      email: "hours@example.com"
    )

    completed_event = Event.create!(
      title: "Completed Event",
      description: "Desc",
      location: "Location",
      event_date: Date.today,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00"),
      required_volunteer_count: 5,
      status: :completed
    )

    open_event = Event.create!(
      title: "Open Event",
      description: "Desc",
      location: "Location",
      event_date: Date.today,
      start_time: Time.zone.parse("12:00"),
      end_time: Time.zone.parse("14:00"),
      required_volunteer_count: 5,
      status: :open
    )

    VolunteerAssignment.create!(volunteer: volunteer, event: completed_event, status: :approved, hours_worked: 2.0)
    VolunteerAssignment.create!(volunteer: volunteer, event: open_event, status: :approved, hours_worked: 5.0)

    assert_equal 2.0, volunteer.total_logged_hours
  end
end
