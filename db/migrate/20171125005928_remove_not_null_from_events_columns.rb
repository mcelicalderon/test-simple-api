class RemoveNotNullFromEventsColumns < ActiveRecord::Migration[5.1]
  def change
    change_column_null :events, :user_id, true
    change_column_null :events, :start_date, true
    change_column_null :events, :end_date, true
    change_column_null :events, :name, true
    change_column_null :events, :description, true
    change_column_null :events, :location_id, true
  end
end
