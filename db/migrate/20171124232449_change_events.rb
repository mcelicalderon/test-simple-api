class ChangeEvents < ActiveRecord::Migration[5.1]
  def up
    change_column :events, :start_date, :date
    change_column :events, :end_date, :date
  end

  def down
    change_column :events, :start_date, :datetime
    change_column :events, :end_date, :datetime
  end
end
