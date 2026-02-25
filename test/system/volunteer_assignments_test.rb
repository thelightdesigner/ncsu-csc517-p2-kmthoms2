require "application_system_test_case"

class VolunteerAssignmentsTest < ApplicationSystemTestCase
  setup do
    @volunteer_assignment = volunteer_assignments(:one)
  end

  test "visiting the index" do
    visit volunteer_assignments_url
    assert_selector "h1", text: "Volunteer assignments"
  end

  test "should create volunteer assignment" do
    visit volunteer_assignments_url
    click_on "New volunteer assignment"

    fill_in "Date logged", with: @volunteer_assignment.date_logged
    fill_in "Event", with: @volunteer_assignment.event_id
    fill_in "Hours worked", with: @volunteer_assignment.hours_worked
    fill_in "Status", with: @volunteer_assignment.status
    fill_in "Volunteer", with: @volunteer_assignment.volunteer_id
    click_on "Create Volunteer assignment"

    assert_text "Volunteer assignment was successfully created"
    click_on "Back"
  end

  test "should update Volunteer assignment" do
    visit volunteer_assignment_url(@volunteer_assignment)
    click_on "Edit this volunteer assignment", match: :first

    fill_in "Date logged", with: @volunteer_assignment.date_logged.to_s
    fill_in "Event", with: @volunteer_assignment.event_id
    fill_in "Hours worked", with: @volunteer_assignment.hours_worked
    fill_in "Status", with: @volunteer_assignment.status
    fill_in "Volunteer", with: @volunteer_assignment.volunteer_id
    click_on "Update Volunteer assignment"

    assert_text "Volunteer assignment was successfully updated"
    click_on "Back"
  end

  test "should destroy Volunteer assignment" do
    visit volunteer_assignment_url(@volunteer_assignment)
    click_on "Destroy this volunteer assignment", match: :first

    assert_text "Volunteer assignment was successfully destroyed"
  end
end
