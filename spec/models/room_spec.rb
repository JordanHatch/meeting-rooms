require 'rails_helper'

RSpec.describe Room, :type => :model do

  describe '.in_use' do
    it 'returns rooms with current events' do
      rooms = create_list(:room, 2)

      # create a current event for the first room
      # so it can be expected to be 'in use'
      create(:current_event, room: rooms[0])

      # only create a past event for the second room
      # so we won't expect it to be 'in use'
      create(:past_event, room: rooms[1])

      result = Room.in_use

      expect(result.size).to eq(1)
      expect(result.first).to eq(rooms[0])
    end
  end

  describe '.not_in_use' do
    it 'returns rooms with no current events' do
      rooms = create_list(:room, 2)

      create(:current_event, room: rooms[0])
      create(:past_event, room: rooms[1])

      result = Room.not_in_use
      expect(result.size).to eq(1)
      expect(result.first).to eq(rooms[1])
    end
  end

  describe '#in_use?' do
    let(:room) { create(:room) }

    it 'returns true if a room has events happening now' do
      create(:current_event, room: room)

      expect(room).to be_in_use
    end

    it 'returns false if a room has no events happening now' do
      create(:past_event, room: room)
      create(:future_event, room: room)

      expect(room).to_not be_in_use
    end
  end

  describe 'short_title' do
    let(:attributes) { attributes_for(:room) }

    it 'is valid with a short string' do
      room = Room.new(attributes.merge(short_title: 'A123'))

      expect(room).to be_valid
    end

    it 'is invalid with a non-unique value' do
      create(:room, short_title: 'A123')

      room = Room.new(attributes.merge(short_title: 'A123'))

      expect(room).to_not be_valid
      expect(room.errors).to have_key(:short_title)
    end

    it 'is invalid when longer than four characters' do
      room = Room.new(attributes.merge(short_title: '12345'))

      expect(room).to_not be_valid
      expect(room.errors).to have_key(:short_title)
    end

    it 'is invalid with spaces' do
      room = Room.new(attributes.merge(short_title: 'A 12'))

      expect(room).to_not be_valid
      expect(room.errors).to have_key(:short_title)
    end
  end

  describe 'custom colour' do
    let(:attributes) { attributes_for(:room) }

    it 'is valid with a hex colour code' do
      room = Room.new(attributes.merge(custom_colour: 'eeeeee'))

      expect(room).to be_valid
    end

    it 'strips the hash character before validation' do
      room = Room.new(attributes.merge(custom_colour: '#eeeeee'))

      expect(room).to be_valid
      expect(room.custom_colour).to eq('eeeeee')
    end

    it 'is invalid when longer than six characters' do
      room = Room.new(attributes.merge(custom_colour: '83wr8eufj'))

      expect(room).to_not be_valid
      expect(room.errors).to have_key(:custom_colour)
    end

    it 'permits only alphanumeric characters' do
      room = Room.new(attributes.merge(custom_colour: '8@">aa'))

      expect(room).to_not be_valid
      expect(room.errors).to have_key(:custom_colour)
    end
  end

  describe '#events_with_gaps' do
    let(:room) { create(:room) }

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

      expect(room.events_with_gaps).to contain_exactly(*expected)
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

      expect(room.events_with_gaps).to contain_exactly(*expected)
    end

    it 'inserts a gap at the start if there are no current events' do
      expected = [
        Gap.new(start_at: Time.now, end_at: 10.minutes.from_now),
        create(:event, room: room,
                       start_at: 10.minutes.from_now,
                       end_at: 30.minutes.from_now),
        Gap.new(start_at: 30.minutes.from_now, end_at: Time.now.end_of_day),
      ]

      expect(room.events_with_gaps).to contain_exactly(*expected)
    end

    it 'includes the custom free message in the gap when present' do
      room = create(:room, custom_free_message: 'Free free free')

      first_gap = room.events_with_gaps.first
      expect(first_gap.title).to eq(room.custom_free_message)
    end

    it 'returns a single gap to the end of the day if there are no events' do
      expected = [
        Gap.new(start_at: Time.now, end_at: Time.now.end_of_day),
      ]

      expect(room.events_with_gaps).to contain_exactly(*expected)
    end

    it 'limits the returned array when limit specified' do
      create(:event, room: room,
                     start_at: 10.minutes.ago,
                     end_at: 10.minutes.from_now)
      create(:event, room: room,
                     start_at: 10.minutes.from_now,
                     end_at: 30.minutes.from_now)
      create(:event, room: room,
                     start_at: 30.minutes.from_now,
                     end_at: 1.hour.from_now)

      output = room.events_with_gaps(limit: 2)

      expect(output.length).to eq(2)
    end
  end
end
