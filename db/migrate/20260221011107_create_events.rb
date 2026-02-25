class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.string :location
      t.date :event_date
      t.time :start_time
      t.time :end_time
      t.integer :required_volunteer_count
      t.integer :status

      t.timestamps
    end
  end
end
