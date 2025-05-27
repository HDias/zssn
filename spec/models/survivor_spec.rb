require 'rails_helper'

RSpec.describe Survivor, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }

    it { should validate_presence_of(:age) }
    it { should validate_numericality_of(:age).only_integer.is_greater_than(0) }

    it { should validate_presence_of(:gender) }
    it { should validate_inclusion_of(:gender).in_array(%w[male female other]) }

    it { should validate_presence_of(:latitude) }
    it { should validate_numericality_of(:latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }

    it { should validate_presence_of(:longitude) }
    it { should validate_numericality_of(:longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }

    it { should validate_presence_of(:infection_reports) }
    it { should validate_numericality_of(:infection_reports).only_integer.is_greater_than_or_equal_to(0).is_less_than_or_equal_to(3) }
  end

  describe 'associations' do
    it { should have_many(:reported_infections).class_name('InfectionReport').with_foreign_key('reporter_id') }
    it { should have_many(:infection_reports_received).class_name('InfectionReport').with_foreign_key('reported_id') }
  end
end
