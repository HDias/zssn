require 'rails_helper'

RSpec.describe InfectionReport, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:reporter_latitude) }
    it { should validate_numericality_of(:reporter_latitude).is_greater_than_or_equal_to(-90).is_less_than_or_equal_to(90) }

    it { should validate_presence_of(:reporter_longitude) }
    it { should validate_numericality_of(:reporter_longitude).is_greater_than_or_equal_to(-180).is_less_than_or_equal_to(180) }
  end

  describe 'associations' do
    it { should belong_to(:reporter).class_name('Survivor').with_foreign_key('reporter_id') }
    it { should belong_to(:reported).class_name('Survivor').with_foreign_key('reported_id').counter_cache(:infection_reports) }
  end

  describe 'custom validations' do
    let(:survivor) { create(:survivor) }
    let(:reporter) { create(:survivor) }
    let(:infected_reporter) { create(:survivor, infected: true) }

    it 'validates reporter cannot report themselves' do
      report = build(:infection_report, reporter: survivor, reported: survivor)

      expect(report).not_to be_valid
      expect(report.errors[:reported_id]).to include("can't report yourself")
    end

    it 'validates reporter cannot report same person twice' do
      create(:infection_report, reporter: reporter, reported: survivor)
      report = build(:infection_report, reporter: reporter, reported: survivor)
      expect(report).not_to be_valid
      expect(report.errors[:reported_id]).to include('already reported this survivor')
    end

    it 'validates reporter cannot be infected' do
      report = build(:infection_report, reporter: infected_reporter, reported: survivor)

      expect(report).not_to be_valid
      expect(report.errors[:reporter_id]).to include('infected survivors cannot report others')
    end
  end

  describe 'callbacks' do
    let(:reported) { create(:survivor) }
    let(:reporter) { create(:survivor) }

    it 'marks survivor as infected after receiving 3 reports' do
      3.times do
        create(:infection_report, reporter: create(:survivor), reported: reported)
      end
      expect(reported.reload.infected).to be true
    end
  end
end
