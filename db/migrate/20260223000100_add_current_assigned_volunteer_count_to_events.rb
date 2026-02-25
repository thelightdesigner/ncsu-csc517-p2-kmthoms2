class AddCurrentAssignedVolunteerCountToEvents < ActiveRecord::Migration[8.0]
  def up
    add_column :events, :current_assigned_volunteer_count, :integer, null: false, default: 0

    say_with_time "Backfilling current_assigned_volunteer_count" do
      Event.reset_column_information
      Event.find_each do |event|
        count = event.volunteer_assignments.where(status: [VolunteerAssignment.statuses[:approved], VolunteerAssignment.statuses[:completed]]).count
        event.update_column(:current_assigned_volunteer_count, count)
      end
    end
  end

  def down
    remove_column :events, :current_assigned_volunteer_count
  end
end
