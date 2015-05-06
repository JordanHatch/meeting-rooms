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
end
