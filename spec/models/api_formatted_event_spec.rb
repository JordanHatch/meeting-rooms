require 'rails_helper'

RSpec.describe ApiFormattedEvent do

  let(:response) {
    {
      'id' => 'event-1',
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
    }
  }

  describe '.build_from_hash' do
    it 'builds a hash of Event attributes from an API response' do
      event = ApiFormattedEvent.build_from_response(response)
      expect(event.attributes).to eq({
        source_id: 'event-1',
        title: 'Important meeting',
        creator: 'Josh Lyman',
        start_at: Time.parse('2015-01-01T12:00:00+01:00'),
        end_at: Time.parse('2015-01-01T13:00:00+01:00'),
      })
    end

    it 'converts all-day events into 24 hour events' do
      event = ApiFormattedEvent.build_from_response(response.merge(
        'start' => {
          'date' => '2015-01-01',
        },
        'end' => {
          'date' => '2015-01-02',
        }
      ))

      expect(event.attributes[:start_at]).to eq(Time.parse('2015-01-01T00:00:00+00:00'))
      expect(event.attributes[:end_at]).to eq(Time.parse('2015-01-02T00:00:00+00:00'))
    end
  end

end
