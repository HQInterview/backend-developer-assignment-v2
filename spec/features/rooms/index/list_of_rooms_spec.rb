require "rails_helper"

include ApplicationHelper

RSpec.feature "rooms#index", type: :feature do

  scenario "should show a list of active rooms" do
    room_1 = create :room
    room_2 = create :room

    visit root_path

    within "#rooms_table" do
      within "#room_#{room_1.id}" do
        expect(page).to have_link room_1.name, href: room_path(room_1)
        expect(page).to have_content room_1.minimal_bid
        expect(page).to have_xpath "//span[@class='expiration-time-table hidden' and text()='#{time_in_milliseconds(room_1.expires_at)}']"
      end
      within "#room_#{room_2.id}" do
        expect(page).to have_link room_2.name, href: room_path(room_2)
        expect(page).to have_content room_2.minimal_bid
        expect(page).to have_xpath "//span[@class='expiration-time-table hidden' and text()='#{time_in_milliseconds(room_2.expires_at)}']"
      end
    end
  end

  scenario "should update the fields in column Remaining time with Javascript", js: true do
    room = create :room

    visit root_path

    within "#rooms_table" do
      within "#room_#{room.id}" do
        expect(page).to have_link room.name, href: room_path(room)
        expect(page).to have_content room.minimal_bid
        expect(page).to_not have_xpath "//span[@class='expiration-time-table hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"
      end
    end
  end

  context "when user is logged in" do
    scenario "button 'Create Sample Data' should create a list of active rooms" do
      expect(Room.count).to be 0

      login_as_user
      visit root_path
      click_link "publish_rooms"

      within "#rooms_table" do
        expect(page).to have_content "Hotel Room"
      end
      expect(Room.count).to_not be 0
      expect(Room.count).to eq Room.active.size
    end
  end

  context "when user is logged out" do
    scenario "button 'Create Sample Data' should show error message" do
      expect(Room.count).to be 0

      visit root_path
      click_link "publish_rooms"

      expect(page).to have_content "Operation failed! Please log in first"
      expect(page).to_not have_content "Hotel Room"
      expect(Room.count).to be 0
    end
  end
end
