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
        expect(page).to have_xpath "//span[@class='expiration-time-table text-green hidden' and text()='#{time_in_milliseconds(room_1.expires_at)}']"
      end
      within "#room_#{room_2.id}" do
        expect(page).to have_link room_2.name, href: room_path(room_2)
        expect(page).to have_content room_2.minimal_bid
        expect(page).to have_xpath "//span[@class='expiration-time-table text-green hidden' and text()='#{time_in_milliseconds(room_2.expires_at)}']"
      end
    end
  end

  scenario "should update the fields in column Remaining time with Javascript", js: true do
    room_1 = create :room, expires_at: 50.seconds.from_now
    room_2 = create :room, expires_at: 63.seconds.from_now
    room_3 = create :room, expires_at: 2.minutes.from_now
    room_4 = create :room, expires_at: 3.seconds.from_now

    visit root_path

    within "#rooms_table" do
      within "#room_#{room_1.id}" do
        # if remaining time is less than 1 minute it should show countdown in red color and not blink
        expect(page).to have_link room_1.name, href: room_path(room_1)
        expect(page).to have_content room_1.minimal_bid
        expect(page).to have_xpath "//span[@class='expiration-time-table text-red']"
        expect(page).to_not have_xpath "//span[@class='expiration-time-table text-green hidden' and text()='#{time_in_milliseconds(room_1.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room_1.expires_at)
      end

      within "#room_#{room_2.id}" do
        # if remaining time is exactly 1 minute it should show countdown in red color and blink once
        expect(page).to have_link room_2.name, href: room_path(room_2)
        expect(page).to have_content room_2.minimal_bid
        expect(page).to have_xpath "//span[@class='expiration-time-table blinking-once text-red']"
        expect(page).to_not have_xpath "//span[@class='expiration-time-table text-green hidden' and text()='#{time_in_milliseconds(room_2.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room_2.expires_at)
        expect(page).to have_xpath "//span[@class='expiration-time-table text-red']"
      end

      within "#room_#{room_3.id}" do
        # if remaining time is more than 1 minute it should show countdown in green color and not blink
        expect(page).to have_link room_3.name, href: room_path(room_3)
        expect(page).to have_content room_3.minimal_bid
        expect(page).to have_xpath "//span[@class='expiration-time-table text-green']"
        expect(page).to_not have_xpath "//span[@class='expiration-time-table text-green hidden' and text()='#{time_in_milliseconds(room_3.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room_3.expires_at)
      end

      within "#room_#{room_4.id}" do
        # if remaining time is less than 0 seconds it should show FINISHED message blue color and not blink
        expect(page).to have_link room_4.name, href: room_path(room_4)
        expect(page).to have_content room_4.minimal_bid
        expect(page).to have_content "FINISHED"
        expect(page).to have_xpath "//span[@class='expiration-time-table text-blue' and text()='FINISHED']"
        expect(page).to_not have_xpath "//span[@class='expiration-time-table text-green hidden' and text()='#{time_in_milliseconds(room_4.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room_4.expires_at)
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
