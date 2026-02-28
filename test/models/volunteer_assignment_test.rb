require "test_helper"

class VolunteerAssignmentTest < ActiveSupport::TestCase
  test "approved assignments cannot exceed event capacity" do
    event = Event.create!(
      title: "Capacity Event",
      description: "Desc",
      location: "Location",
      event_date: Date.today + 1.day,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("10:00"),
      required_volunteer_count: 1,
      status: :open
    )

    v1 = Volunteer.create!(
      username: "cap_user_1",
      password: "password",
      full_name: "Cap User 1",
      email: "cap1@example.com"
    )
    v2 = Volunteer.create!(
      username: "cap_user_2",
      password: "password",
      full_name: "Cap User 2",
      email: "cap2@example.com"
    )

    VolunteerAssignment.create!(volunteer: v1, event: event, status: :approved)
    second_assignment = VolunteerAssignment.new(volunteer: v2, event: event, status: :approved)

    assert_not second_assignment.valid?
    assert_includes second_assignment.errors[:base], "Event has no available volunteer slots"
  end
end
