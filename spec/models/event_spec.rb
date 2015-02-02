require 'rails_helper'

RSpec.describe Event, :type => :model do

  let(:valid_attributes) {
    {
      source_id: 'example@google.com',
      title: 'An event',
      creator: 'CJ Cregg',
      start_at: Time.now,
      end_at: 30.minutes.from_now,
      room_id: 1,
    }
  }

  it 'is not private by default' do
    event = Event.create(valid_attributes)

    expect(event.private).to eq(false)
    expect(event).to_not be_private
  end

  it 'can be created as private' do
    event = Event.create(valid_attributes.merge(private: true))

    expect(event.private).to eq(true)
    expect(event).to be_private
  end

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

  describe '.future' do
    before do
      Timecop.freeze
    end

    it 'returns events where start_at is after now' do
      events = [
        create(:future_event),
        create(:current_event),
        create(:past_event),
      ]

      events = Event.future

      expect(events.size).to eq(1)
      expect(events.first).to eq(events.first)
    end
  end

end
