require 'rails_helper'

describe 'listing events', type: :feature do
  let(:room) { create(:room) }

  before do
    Timecop.freeze
  end

  def expected_duration(start_at:, end_at:)
    "#{start_at.strftime('%l:%M%P')} → #{end_at.strftime('%l:%M%P')}"
  end

  it 'shows a list of events for the room' do
    events = [
      create(:current_event, room: room, end_at: 10.minutes.from_now),
      create(:future_event, room: room, start_at: 10.minutes.from_now)
    ]

    visit "/rooms/#{room.to_param}"

    within '.events li:nth-of-type(1)' do
      expect(page).to have_content(events[0].title)
      expect(page).to have_content(expected_duration(
                                     start_at: events[0].start_at,
                                     end_at: events[0].end_at))
    end

    within '.events li:nth-of-type(2)' do
      expect(page).to have_content(events[1].title)
      expect(page).to have_content(expected_duration(
                                     start_at: events[1].start_at,
                                     end_at: events[1].end_at))
    end
  end

  it "inserts gaps between events that don't immediately follow each other" do
    events = [
      create(:current_event, room: room, end_at: 10.minutes.from_now),
      create(:future_event, room: room, start_at: 20.minutes.from_now)
    ]

    visit "/rooms/#{room.to_param}"

    within '.events li:nth-of-type(1)' do
      expect(page).to have_content(events[0].title)
    end

    within '.events li:nth-of-type(2)' do
      expect(page).to have_content('Available')
      expect(page).to have_content(expected_duration(
                                     start_at: events[0].end_at,
                                     end_at: events[1].start_at))
    end

    within '.events li:nth-of-type(3)' do
      expect(page).to have_content(events[1].title)
    end
  end

  it 'prepends a gap if there is no current event' do
    event = create(:future_event, room: room, start_at: 20.minutes.from_now)

    visit "/rooms/#{room.to_param}"

    within '.events li:nth-of-type(1)' do
      expect(page).to have_content('Available')
      expect(page).to have_content(expected_duration(
                                     start_at: Time.now,
                                     end_at: event.start_at))
    end

    within '.events li:nth-of-type(2)' do
      expect(page).to have_content(event.title)
    end
  end

  it 'uses the custom free message in gaps' do
    room = create(:room, custom_free_message: 'Free!')
    events = [
      create(:future_event, room: room, start_at: 20.minutes.from_now,
                                        end_at: 30.minutes.from_now),
      # NOTE: 10 minute gap
      create(:future_event, room: room, start_at: 40.minutes.from_now),
    ]

    visit "/rooms/#{room.to_param}"

    within '.events li:nth-of-type(1)' do
      expect(page).to have_content('Free!')
    end

    within '.events li:nth-of-type(3)' do
      expect(page).to have_content('Free!')
    end

    within '.events li:nth-of-type(5)' do
      expect(page).to have_content('Free!')
    end
  end

  it 'shows a different title when an event is private' do
    create(:current_event, room: room, private: true)

    visit "/rooms/#{room.to_param}"

    within '.events li:nth-of-type(1)' do
      expect(page).to have_content("Private event")
    end
  end
end
