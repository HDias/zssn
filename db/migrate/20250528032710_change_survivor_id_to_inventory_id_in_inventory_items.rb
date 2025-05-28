class ChangeSurvivorIdToInventoryIdInInventoryItems < ActiveRecord::Migration[8.0]
  def change
    remove_foreign_key :inventory_items, :survivors
    remove_reference :inventory_items, :survivor
    add_reference :inventory_items, :inventory, null: false, foreign_key: true
  end
end
