class CreateAircrafts < ActiveRecord::Migration[8.1]
  def change
    create_table :aircrafts do |t|
      t.references :flight_school, null: false, foreign_key: true
      t.string :tail_number
      t.string :model
      t.string :status
      t.text :notes

      t.timestamps
    end
    add_index :aircrafts, :tail_number
  end
end
