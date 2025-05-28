require 'rails_helper'

RSpec.describe GlobalItemStock, type: :model do
  describe 'associations' do
    it { should belong_to(:item) }
  end

  describe 'validations' do
    subject { build(:global_item_stock) }

    it { should validate_presence_of(:total_quantity) }
    it { should validate_numericality_of(:total_quantity).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_uniqueness_of(:item_id).with_message("already has a global stock record") }
  end
end
