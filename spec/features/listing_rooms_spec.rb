require 'rails_helper'

describe 'listing rooms', type: :feature do
  def expect_presence_of_room(title:, status:)
    el = page.find('li.room', text: title)
    expect(el).to have_selector('.status', text: status)
  end

  it 'shows a list of each room' do
    in_use = create_list(:room_in_use, 3)
    not_in_use = create_list(:room, 3)

    visit '/rooms'

    expect(page).to have_selector('li.room', count: 6)

    in_use.each do |room|
      expect_presence_of_room(title: room.title, status: room.events.first.title)
    end

    not_in_use.each do |room|
      expect_presence_of_room(title: room.title, status: 'Available')
    end
  end

  it 'includes the custom free message for each room' do
    not_in_use = create(:room, custom_free_message: 'Completely free')

    visit '/rooms'

    expect(page).to have_selector('li.room', count: 1)

    expect_presence_of_room(title: not_in_use.title,
                            status: not_in_use.custom_free_message)
  end
end
