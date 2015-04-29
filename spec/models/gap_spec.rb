require 'rails_helper'

RSpec.describe Gap, :type => :model do

  subject {
    Gap.new(start_at: Time.now, end_at: 10.minutes.from_now, title: 'Available')
  }

  before do
    Timecop.freeze(
      Time.now.beginning_of_hour
    )
  end

  describe '#<=>' do
    it 'is equal to another Gap if the start_at and end_at values are the same' do
      other = Gap.new(start_at: subject.start_at, end_at: subject.end_at)
      expect(subject).to eq(other)
    end

    it 'is not equal to another Gap if start_at or end_at are different' do
      other = Gap.new(start_at: 10.minutes.ago, end_at: 5.minutes.from_now)
      expect(subject).to_not eq(other)
    end

    it 'ignores fractional differences in seconds' do
      other = Gap.new(start_at: (subject.start_at + 0.25), end_at: (subject.end_at + 0.5))
      expect(subject).to eq(other)
    end
  end

  describe '#title' do
    it 'returns a string for the title' do
      expect(subject.title).to be_a(String)
    end
  end

  describe '#private' do
    it 'returns false' do
      expect(subject).to_not be_private
    end
  end

end
