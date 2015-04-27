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

end
