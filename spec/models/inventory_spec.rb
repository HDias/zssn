require 'rails_helper'

RSpec.describe Inventory do
  let(:survivor) { create(:survivor) }
  let(:inventory) { described_class.new(survivor) }

  describe '#add_item' do
    context 'when adding a water item' do
      let(:item) { create(:item, :water) }
      let!(:global_stock) { create(:global_item_stock, item:, total_quantity: 10) }

      it 'creates a new inventory item with quantity 1 and decreases global stock' do
        expect {
          inventory.add_item(item)
        }.to change(InventoryItem, :count).by(1)
          .and change { global_stock.reload.total_quantity }.by(-1)

        inventory_item = survivor.inventory_items.find_by(item: item)
        expect(inventory_item.quantity).to eq(1)
        expect(inventory_item.item.point_value).to eq(4)
      end

      context 'when global stock is empty' do
        let!(:global_stock) { create(:global_item_stock, item:, total_quantity: 0) }

        it 'returns false and does not create inventory item' do
          expect {
            expect(inventory.add_item(item)).to be false
          }.to not_change(InventoryItem, :count)
            .and not_change { global_stock.reload.total_quantity }
        end
      end
    end

    context 'when adding a food item' do
      let(:item) { create(:item, :food) }
      let!(:global_stock) { create(:global_item_stock, item:, total_quantity: 10) }

      it 'creates a new inventory item with quantity 1 and decreases global stock' do
        expect {
          inventory.add_item(item)
        }.to change(InventoryItem, :count).by(1)
          .and change { global_stock.reload.total_quantity }.by(-1)

        inventory_item = survivor.inventory_items.find_by(item: item)
        expect(inventory_item.quantity).to eq(1)
        expect(inventory_item.item.point_value).to eq(3)
      end
    end

    context 'when adding a medicine item' do
      let(:item) { create(:item, :medicine) }
      let!(:global_stock) { create(:global_item_stock, item:, total_quantity: 10) }

      it 'creates a new inventory item with quantity 1 and decreases global stock' do
        expect {
          inventory.add_item(item)
        }.to change(InventoryItem, :count).by(1)
          .and change { global_stock.reload.total_quantity }.by(-1)

        inventory_item = survivor.inventory_items.find_by(item: item)
        expect(inventory_item.quantity).to eq(1)
        expect(inventory_item.item.point_value).to eq(2)
      end
    end

    context 'when adding an ammunition item' do
      let(:item) { create(:item, :ammunition) }
      let!(:global_stock) { create(:global_item_stock, item:, total_quantity: 10) }

      it 'creates a new inventory item with quantity 1 and decreases global stock' do
        expect {
          inventory.add_item(item)
        }.to change(InventoryItem, :count).by(1)
          .and change { global_stock.reload.total_quantity }.by(-1)

        inventory_item = survivor.inventory_items.find_by(item: item)
        expect(inventory_item.quantity).to eq(1)
        expect(inventory_item.item.point_value).to eq(1)
      end
    end

    context 'when adding an item that already exists in inventory' do
      let(:item) { create(:item, :water) }
      let!(:global_stock) { create(:global_item_stock, item:, total_quantity: 10) }
      let!(:existing_item) { create(:inventory_item, survivor:, item: item, quantity: 2) }

      it 'increments the quantity of the existing item and decreases global stock' do
        expect {
          inventory.add_item(item)
        }.to not_change(InventoryItem, :count)
          .and change { global_stock.reload.total_quantity }.by(-1)

        existing_item.reload
        expect(existing_item.quantity).to eq(3)
      end
    end
  end
end
