class AddStatusColumnToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :state, :string, null: false, default: 'draft'
  end
end
