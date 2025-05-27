class CreateInfectionReports < ActiveRecord::Migration[8.0]
  def change
    create_table :infection_reports do |t|
      t.integer :reporter_id
      t.integer :reported_id
      t.float :reporter_latitude
      t.float :reporter_longitude

      t.timestamps
    end
  end
end
