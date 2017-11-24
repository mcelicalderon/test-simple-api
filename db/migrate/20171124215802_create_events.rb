class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.belongs_to :user, foreign_key: true
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.references :location, foreign_key: true

      t.timestamps null: false
    end
  end
end
