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

  describe '.new' do
    it 'builds a hash of Event attributes from an API response' do
      event = ApiFormattedEvent.new(response)
      expect(event.attributes).to eq({
        source_id: 'event-1',
        title: 'Important meeting',
        creator: 'Josh Lyman',
        start_at: Time.parse('2015-01-01T12:00:00+01:00'),
        end_at: Time.parse('2015-01-01T13:00:00+01:00'),
      })
    end

    it 'converts all-day events into 24 hour events' do
      event = ApiFormattedEvent.new(response.merge(
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

    it 'gracefully handles a missing event creator' do
      event = ApiFormattedEvent.new(response.merge('creator' => nil))

      expect(event.attributes[:creator]).to be_nil
    end
  end

  describe '#updateable_attributes' do
    it 'returns a hash of core attributes' do
      atts = ApiFormattedEvent.new(response).updateable_attributes

      expect(atts).to be_a(Hash)
      expect(atts[:title]).to eq('Important meeting')
    end

    it 'excludes the source_id field' do
      event = ApiFormattedEvent.new(response)

      expect(event.updateable_attributes).to_not have_key(:source_id)
    end
  end

  describe '#declined?' do
    it 'returns true if the attendees list contains the calendar with a declined response' do
      event = ApiFormattedEvent.new(response.merge(
        'attendees' => [{
          'self' => true,
          'responseStatus' => 'declined',
        }],
      ))

      expect(event).to be_declined
    end

    it 'returns false if the attendees list contains the calendar with another response' do
      event = ApiFormattedEvent.new(response.merge(
        'attendees' => [{
          'self' => true,
          'responseStatus' => 'accepted',
        }],
      ))

      expect(event).to_not be_declined
    end

    it 'returns false if there is no attendee list' do
      event = ApiFormattedEvent.new(response.merge('attendees' => nil))

      expect(event).to_not be_declined
    end

    it 'returns false if the calendar is not present in the attendee list' do
      event = ApiFormattedEvent.new(response.merge(
        'attendees' => [
          { 'responseStatus' => 'accepted' },
          { 'responseStatus' => 'accepted', 'self' => false },
        ],
      ))

      expect(event).to_not be_declined
    end
  end

end
