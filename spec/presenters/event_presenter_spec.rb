require 'rails_helper'

RSpec.describe EventPresenter do
  let(:event) { create(:event) }
  let(:presenter) { EventPresenter.new(event) }

  describe '#as_json' do
    it 'returns event details' do
      expect(presenter.as_json).to eq(
        {
          title: event.title,
          start_at: event.start_at.strftime('%l:%M%P'),
          end_at: event.end_at.strftime('%l:%M%P'),
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

end
