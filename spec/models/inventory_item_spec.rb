require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  describe 'associations' do
    it { should belong_to(:inventory) }
    it { should belong_to(:item) }
  end

  describe 'validations' do
    subject { build(:inventory_item) }

    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }

    describe 'uniqueness validation' do
      let(:inventory) { create(:inventory) }
      let(:item) { create(:item, :water) }
      subject { build(:inventory_item, inventory: inventory, item: item) }

      it { should validate_uniqueness_of(:item_id).scoped_to(:inventory_id).with_message("already exists in inventory") }
    end
  end
end
