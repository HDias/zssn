require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'associations' do
    it { should have_many(:inventory_items) }
    it { should have_one(:global_item_stock) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:point_value) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:kind) }

    it { should validate_numericality_of(:point_value).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }
    it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }

    it do
      should define_enum_for(:kind).
        with_values(water: 'water', food: 'food', medicine: 'medicine', ammunition: 'ammunition').
        backed_by_column_of_type(:string)
    end
  end
end
