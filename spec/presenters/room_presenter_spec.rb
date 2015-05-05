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

  describe '#events_with_gaps' do
    before do
      Timecop.freeze
    end

    it 'returns list of current and future events, with a gap at the end' do
      expected = [
        create(:event, room: room,
                       start_at: 10.minutes.ago,
                       end_at: 10.minutes.from_now),
        create(:event, room: room,
                       start_at: 10.minutes.from_now,
                       end_at: 30.minutes.from_now),
        create(:event, room: room,
                       start_at: 30.minutes.from_now,
                       end_at: 1.hour.from_now),
        Gap.new(start_at: 1.hour.from_now, end_at: Time.now.end_of_day),
      ]

      expect(presenter.events_with_gaps).to contain_exactly(*expected)
    end

    it "inserts gaps between events that don't follow on from each other" do
      expected = [
        create(:event, room: room,
                       start_at: 10.minutes.ago,
                       end_at: 10.minutes.from_now),
        Gap.new(start_at: 10.minutes.from_now, end_at: 30.minutes.from_now),
        create(:event, room: room,
                       start_at: 30.minutes.from_now,
                       end_at: 50.minutes.from_now),
        Gap.new(start_at: 50.minutes.from_now, end_at: 1.hour.from_now),
        create(:event, room: room,
                       start_at: 1.hour.from_now,
                       end_at: 2.hours.from_now),
        Gap.new(start_at: 2.hours.from_now, end_at: Time.now.end_of_day),
      ]

      expect(presenter.events_with_gaps).to contain_exactly(*expected)
    end

    it 'inserts a gap at the start if there are no current events' do
      expected = [
        Gap.new(start_at: Time.now, end_at: 10.minutes.from_now),
        create(:event, room: room,
                       start_at: 10.minutes.from_now,
                       end_at: 30.minutes.from_now),
        Gap.new(start_at: 30.minutes.from_now, end_at: Time.now.end_of_day),
      ]

      expect(presenter.events_with_gaps).to contain_exactly(*expected)
    end

    it 'includes the custom free message in the gap when present' do
      room = create(:room, custom_free_message: 'Free free free')
      presenter = RoomPresenter.new(room)

      first_gap = presenter.events_with_gaps.first
      expect(first_gap.title).to eq(room.custom_free_message)
    end

    it 'returns a single gap to the end of the day if there are no events' do
      expected = [
        Gap.new(start_at: Time.now, end_at: Time.now.end_of_day),
      ]

      expect(presenter.events_with_gaps).to contain_exactly(*expected)
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

end
