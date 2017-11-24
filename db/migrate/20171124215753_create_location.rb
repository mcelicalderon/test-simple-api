class CreateLocation < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      # Location information just has a name for the exercise
      t.string :name

      t.timestamps null: false
    end
  end
end
