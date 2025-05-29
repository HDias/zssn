# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trade do
  describe 'validations' do
    let(:barterer) { create(:survivor) }
    let(:counterpart) { create(:survivor) }
    let(:trade) { Trade.new(barterer: barterer, counterpart: counterpart) }

    context 'when barterer and counterpart are the same' do
      let(:trade) { Trade.new(barterer: barterer, counterpart: barterer) }

      it 'is invalid' do
        expect(trade.valid?).to be false
        expect(trade.errors).to include('A survivor cannot trade with themselves')
      end
    end

    context 'when either survivor is infected' do
      let(:infected_survivor) { create(:survivor, infected: true) }

      it 'is invalid when barterer is infected' do
        trade = Trade.new(barterer: infected_survivor, counterpart: counterpart)
        expect(trade.valid?).to be false
        expect(trade.errors).to include('Infected survivors cannot trade')
      end

      it 'is invalid when counterpart is infected' do
        trade = Trade.new(barterer: barterer, counterpart: infected_survivor)
        expect(trade.valid?).to be false
        expect(trade.errors).to include('Infected survivors cannot trade')
      end
    end
  end

  describe '#exchange_items' do
    let(:barterer) { create(:survivor) }
    let(:counterpart) { create(:survivor) }
    let(:water) { create(:item, :water) }
    let(:food) { create(:item, :food) }
    let(:medicine) { create(:item, :medicine) }
    let(:ammunition) { create(:item, :ammunition) }

    before do
      create(:global_item_stock, item: water, total_quantity: 10)
      create(:global_item_stock, item: food, total_quantity: 10)
      create(:global_item_stock, item: medicine, total_quantity: 10)
      create(:global_item_stock, item: ammunition, total_quantity: 10)

      2.times { barterer.inventory.add_item(water) }
      3.times { barterer.inventory.add_item(food) }
      2.times { counterpart.inventory.add_item(medicine) }
      4.times { counterpart.inventory.add_item(ammunition) }
    end

    context 'when point values are equal' do
      let(:barterer_items) { { water.id => 1, food.id => 1 } } # 4 + 3 = 7 points
      let(:counterpart_items) { { medicine.id => 2, ammunition.id => 3 } } # (2 * 2) + (1 * 3) = 7 points

      it 'successfully exchanges items' do
        trade = Trade.new(barterer:, counterpart:)

        expect(trade.exchange_items(barterer_items, counterpart_items)).to be true

        expect(barterer.inventory.inventory_items.find_by(item: water).quantity).to eq(1)
        expect(barterer.inventory.inventory_items.find_by(item: food).quantity).to eq(2)
        expect(barterer.inventory.inventory_items.find_by(item: medicine).quantity).to eq(2)
        expect(barterer.inventory.inventory_items.find_by(item: ammunition).quantity).to eq(3)

        expect(counterpart.inventory.inventory_items.find_by(item: water).quantity).to eq(1)
        expect(counterpart.inventory.inventory_items.find_by(item: food).quantity).to eq(1)
        expect(counterpart.inventory.inventory_items.find_by(item: medicine)).to be_nil
        expect(counterpart.inventory.inventory_items.find_by(item: ammunition).quantity).to eq(1)
      end
    end

    context 'when point values are not equal' do
      let(:barterer_items) { { water.id => 1 } } # 4 points
      let(:counterpart_items) { { ammunition.id => 3 } } # 3 points

      it 'fails to exchange items' do
        trade = Trade.new(barterer:, counterpart:)
        expect(trade.exchange_items(barterer_items, counterpart_items)).to be false
        expect(trade.errors).to include('Point values must be equal for both sides of the trade')
      end
    end

    context 'when survivor does not have enough items' do
      let(:barterer_items) { { water.id => 3 } } # Trying to trade 3 waters when only has 2
      let(:counterpart_items) { { medicine.id => 6 } } # 12 points

      it 'fails to exchange items' do
        trade = Trade.new(barterer:, counterpart:)

        expect(trade.exchange_items(barterer_items, counterpart_items)).to be false
        expect(trade.errors).to include("#{barterer.name} doesn't have enough #{water.name}")
      end
    end
  end
end
