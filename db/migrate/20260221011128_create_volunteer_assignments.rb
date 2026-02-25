class CreateVolunteerAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :volunteer_assignments do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.integer :status
      t.float :hours_worked
      t.datetime :date_logged

      t.timestamps
    end
  end
end
