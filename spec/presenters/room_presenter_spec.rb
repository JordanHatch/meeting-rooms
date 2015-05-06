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
    it 'returns "In use" if the room.in_use? returns true' do
      expect(room).to receive(:in_use?).and_return(true)

      expect(presenter.status_message).to eq('In use')
    end

    it 'returns "Available" if room.in_use? returns false' do
      expect(room).to receive(:in_use?).and_return(false)

      expect(presenter.status_message).to eq('Available')
    end

    describe 'given custom messages' do
      let(:room) { create(:room,
                          custom_free_message: 'Custom available',
                          custom_busy_message: 'Not available') }

      it 'returns the custom free message' do
        presenter = RoomPresenter.new(room)

        expect(room).to receive(:in_use?).and_return(false)
        expect(presenter.status_message).to eq('Custom available')
      end

      it 'returns the custom busy message' do
        presenter = RoomPresenter.new(room)

        expect(room).to receive(:in_use?).and_return(true)
        expect(presenter.status_message).to eq('Not available')
      end
    end
  end

  describe '#as_mustache_context' do
    it 'passes the limit argument through to events_with_gaps' do
      expect(presenter).to receive(:events_with_gaps).with(limit: 5).and_return([])

      presenter.as_mustache_context(limit: 5)
    end
  end

end
