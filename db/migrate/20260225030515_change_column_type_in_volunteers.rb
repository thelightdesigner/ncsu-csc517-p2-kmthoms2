class ChangeColumnTypeInVolunteers < ActiveRecord::Migration[8.0]
  def change
    change_column :volunteers, :phone_number, :string
  end
end
