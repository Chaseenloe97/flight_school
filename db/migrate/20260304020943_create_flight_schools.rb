class CreateFlightSchools < ActiveRecord::Migration[8.1]
  def change
    create_table :flight_schools do |t|
      t.string :name
      t.string :location
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
