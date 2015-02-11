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
      expect_presence_of_room(title: room.title, status: 'In use')
    end

    not_in_use.each do |room|
      expect_presence_of_room(title: room.title, status: 'Not in use')
    end
  end
end
