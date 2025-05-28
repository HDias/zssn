class CreateInventories < ActiveRecord::Migration[8.0]
  def change
    create_table :inventories do |t|
      t.references :survivor, null: false, foreign_key: true
      t.integer :total_items, null: false, default: 0

      t.timestamps
    end
  end
end
