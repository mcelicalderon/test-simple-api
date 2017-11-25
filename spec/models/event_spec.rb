require 'rails_helper'

RSpec.describe Event, type: :model do
  subject { build(:event, start_date: Date.today, end_date: Date.today + 5) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:location) }
  end

  describe '#duration' do
    it 'returns event duration based on event start and end' do
      expect(subject.duration).to eq(5)
    end
  end

  describe '#duration=' do
    context 'when start date is also passed as an attribute' do
      it 'assigns an end date based on duration and start date' do
        subject.end_date = nil
        subject.duration = 15

        expect(subject.start_date).to eq(Date.today)
        expect(subject.end_date).to   eq(Date.today + 15)
      end
    end

    context 'when end date is also passed as an attribute' do
      it 'assigns a start date based on duration and end date' do
        subject.start_date = nil
        subject.duration = 15

        expect(subject.end_date).to eq(Date.today + 5)
        expect(subject.start_date).to eq(Date.today - 10)
      end
    end
  end
end
