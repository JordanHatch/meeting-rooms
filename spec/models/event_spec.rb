require 'rails_helper'

RSpec.describe Event, :type => :model do

  describe '.current' do
    before do
      Timecop.freeze
    end

    it 'returns events where start_at is before now and end_at is after now' do
      included_event = create(:event, start_at: 30.minutes.ago,
                                      end_at: 10.minutes.from_now)
      other_events = [
        create(:event, start_at: 30.minutes.from_now),
        create(:event, start_at: 30.minutes.ago, end_at: 1.minute.ago)
      ]

      events = Event.current

      expect(events.size).to eq(1)
      expect(events.first).to eq(included_event)
    end
  end

end
