require 'rails_helper'

RSpec.describe RoomPresenter do

  let(:room) { create(:room) }
  let(:presenter) { RoomPresenter.new(room) }

  describe '#method_missing' do
    it 'invokes the requested method on the room if it exists' do
      expect(room).to receive(:title).and_return('foo')
      expect(presenter.title).to eq('foo')
    end

    it 'raises an exception if the method does not exist' do
      expect{ presenter.foo }.to raise_error(NoMethodError)
    end
  end

  describe '#status_message' do
    it 'returns the title of the first event or gap' do
      expect(room).to receive(:events_with_gaps).and_return([
        build(:event, title: 'Example')
      ])

      expect(presenter.status_message).to eq('Example')
    end
  end
end
