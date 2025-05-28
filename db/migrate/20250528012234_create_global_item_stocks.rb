class CreateGlobalItemStocks < ActiveRecord::Migration[8.0]
  def change
    create_table :global_item_stocks do |t|
      t.references :item, null: false, foreign_key: true
      t.integer :total_quantity, null: false, default: 0

      t.timestamps
    end
  end
end
