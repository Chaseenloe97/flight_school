class CreateMaintenanceLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_logs do |t|
      t.references :aircraft, null: false, foreign_key: true
      t.datetime :logged_at
      t.string :log_type
      t.decimal :hobbs_hours
      t.decimal :tach_hours
      t.text :notes

      t.timestamps
    end
  end
end
