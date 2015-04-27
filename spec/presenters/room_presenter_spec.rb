require 'rails_helper'

RSpec.describe RoomPresenter do

  let(:room) { create(:room) }
  subject { RoomPresenter.new(room) }

  describe '#method_missing' do
    it 'invokes the requested method on the room if it exists' do
      expect(room).to receive(:title).and_return('foo')
      expect(subject.title).to eq('foo')
    end

    it 'raises an exception if the method does not exist' do
      expect{ subject.foo }.to raise_error(NoMethodError)
    end
  end

  describe '#events_with_gaps' do
    before do
      Timecop.freeze
    end

    it 'returns the list of current and future events' do
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
      ]

      expect(subject.events_with_gaps).to contain_exactly(*expected)
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
      ]

      expect(subject.events_with_gaps).to contain_exactly(*expected)
    end

    it 'inserts a gap at the start if there are no current events' do
      expected = [
        Gap.new(start_at: Time.now, end_at: 10.minutes.from_now),
        create(:event, room: room,
                       start_at: 10.minutes.from_now,
                       end_at: 30.minutes.from_now),
      ]

      expect(subject.events_with_gaps).to contain_exactly(*expected)
    end

    it 'returns an empty array if there are no events' do
      expect(subject.events_with_gaps).to be_empty
    end
  end

  describe '#status_message' do
    it 'returns "In use" if the room.in_use? returns true' do
      expect(room).to receive(:in_use?).and_return(true)

      expect(subject.status_message).to eq('In use')
    end

    it 'returns "Not in use" if room.in_use? returns false' do
      expect(room).to receive(:in_use?).and_return(false)

      expect(subject.status_message).to eq('Not in use')
    end
  end

end
