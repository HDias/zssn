class CreateItems < ActiveRecord::Migration[8.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.integer :point_value, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :kind, null: false

      t.timestamps
    end
  end
end
