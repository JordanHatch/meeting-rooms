require 'rails_helper'

RSpec.describe EventPresenter do
  let(:event) { create(:event) }
  let(:presenter) { EventPresenter.new(event) }

  describe '#as_json' do
    it 'returns event details' do
      expect(presenter.as_json).to eq(
        {
          title: event.title,
          start_at: {
            formatted: event.start_at.strftime('%k:%M'),
            timestamp: event.start_at,
          },
          end_at: {
            formatted: event.end_at.strftime('%k:%M'),
            timestamp: event.end_at,
          },
          status: 'in_use',
        }
      )
    end
  end

  describe '#title' do
    it 'returns the event title for a public event' do
      event.private = false

      expect(presenter.title).to eq(event.title)
    end

    it 'returns a message for a private event' do
      event.private = true

      expect(presenter.title).to eq("Private event")
    end
  end

  describe '#formatted_start_at' do
    before do
      Timecop.freeze
    end

    it 'returns the formatted time when not now' do
      event.start_at = 10.minutes.from_now

      expected = event.start_at.strftime('%k:%M')

      expect(presenter.formatted_start_at).to eq(expected)
    end

    it 'returns "Now" when the time is equal to now' do
      event.start_at = Time.now

      expect(presenter.formatted_start_at).to eq("Now")
    end
  end

  describe '#formatted_end_at' do
    before do
      Timecop.freeze
    end

    it 'returns the formatted time' do
      expected = event.end_at.strftime('%k:%M')

      expect(presenter.formatted_end_at).to eq(expected)
    end

    it 'returns "Until the end of the day" when the time is equal to the end of the day' do
      event.end_at = Time.now.end_of_day

      expect(presenter.formatted_end_at).to eq("Until the end of the day")
    end
  end

end
