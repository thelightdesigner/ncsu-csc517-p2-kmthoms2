class CreateVolunteers < ActiveRecord::Migration[8.0]
  def change
    create_table :volunteers do |t|
      t.string :username
      t.string :password
      t.string :full_name
      t.string :email
      t.integer :phone_number
      t.string :address
      t.text :skills
      t.text :interests
      t.float :total_hours

      t.timestamps
    end
  end
end
