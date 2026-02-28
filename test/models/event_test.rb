require "test_helper"

class EventTest < ActiveSupport::TestCase
  test "required volunteer count cannot exceed sqlite integer max" do
    event = Event.new(
      title: "Large Event",
      description: "Desc",
      location: "Location",
      event_date: Date.today + 1.day,
      start_time: Time.zone.parse("09:00"),
      end_time: Time.zone.parse("11:00"),
      required_volunteer_count: 2_147_483_648
    )

    assert_not event.valid?
    assert_includes event.errors[:required_volunteer_count], "must be less than or equal to 2147483647"
  end
end
