class CreateDowntimeEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :downtime_events do |t|
      t.references :aircraft, null: false, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.string :reason_type
      t.text :description
      t.integer :created_by_id

      t.timestamps
    end
    add_index :downtime_events, :created_by_id
  end
end
