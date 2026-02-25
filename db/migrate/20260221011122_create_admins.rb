class CreateAdmins < ActiveRecord::Migration[8.0]
  def change
    create_table :admins do |t|
      t.string :username
      t.string :password
      t.string :full_name
      t.string :email

      t.timestamps
    end
  end
end
