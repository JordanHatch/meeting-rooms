require 'rails_helper'

RSpec.describe EventImporter do

  let(:room) { create(:room) }
  let(:mock_calendar_api) { double(:calendar_api) }
  let(:events) {
    [
      {
        'id' => 'event-1@google.com',
        'summary' => 'Important meeting',
        'creator' => {
          'email' => 'josh@whitehouse.gov',
          'displayName' => 'Josh Lyman',
        },
        'start' => {
          'dateTime' => '2015-01-01T12:00:00+01:00',
        },
        'end' => {
          'dateTime' => '2015-01-01T13:00:00+01:00',
        },
      },
      {
        'id' => 'event-2@google.com',
        'summary' => 'Big Block of Cheese Day',
        'creator' => {
          'email' => 'leo@whitehouse.gov',
          'displayName' => 'Leo McGarry',
        },
        'start' => {
          'date' => '2015-01-05',
        },
        'end' => {
          'date' => '2015-01-05',
        },
      },
    ]
  }

  before do
    MeetingRooms.services(:calendar_api, mock_calendar_api)
  end

  describe '#import' do
    before do
      expect(mock_calendar_api).to receive(:events).with(
        hash_including(calendar_id: room.calendar_id)
      ).and_return(events)
    end

    it 'creates Event objects for each event returned from the Calendar API' do
      importer = EventImporter.new(room: room)

      expect{ importer.import }.to change{ room.events.count }.by(2)
    end

    it 'updates an existing Event if it already exists for the room' do
      existing_event = create(:event, source_id: 'event-1@google.com',
                                      title: 'An old title',
                                      room: room)

      importer = EventImporter.new(room: room)
      expect{ importer.import }.to change{ room.events.count }.by(1)

      existing_event.reload
      expect(existing_event.title).to eq('Important meeting')
    end

    it 'ignores an event if the calendar has declined' do
      events.push({
        'id' => 'event-3@google.com',
        'summary' => 'Declined event',
        'creator' => {
          'email' => 'toby@whitehouse.gov',
          'displayName' => 'Toby Ziegler',
        },
        'start' => {
          'dateTime' => '2015-01-01T12:00:00+01:00',
        },
        'end' => {
          'dateTime' => '2015-01-01T13:00:00+01:00',
        },
        'attendees' => [{
          'self' => true,
          'responseStatus' => 'declined',
        }],
      })

      importer = EventImporter.new(room: room)
      importer.import

      expect(Event.where(source_id: 'event-3@google.com')).to be_empty
    end
  end

end
