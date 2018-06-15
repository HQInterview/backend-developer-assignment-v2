require "rails_helper"

include ApplicationHelper

RSpec.feature "rooms#show", type: :feature do

  context "when Javascript is disabled" do

    scenario "the remaining time should be hidden" do
      room = create :room, expires_at: 2.minutes.from_now

      visit room_path(room)

      expect(page).to have_content "Remaining Time: "
      expect(page).to have_xpath "//span[@class='expiration-time-room text-green hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"
      expect(page).to_not have_content "This Auction has FINISHED"
    end

    scenario "the FINISHED message should be shown" do
      room = create :room, expires_at: 1.minute.ago

      visit room_path(room)

      expect(page).to have_content "This Auction has FINISHED"
      expect(page).to_not have_content "Remaining Time: "
      expect(page).to_not have_xpath "//span[@class='expiration-time-room text-green hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"      
      expect(page).to_not have_content time_in_milliseconds(room.expires_at)
    end
  end

  context "when auction is still active", js: true do

    context "and there is more than 1 minute remaining" do
      scenario "the countdown should be green and not blinking" do
        room = create :room, expires_at: 2.minutes.from_now

        visit room_path(room)

        expect(page).to have_content "Remaining Time: "
        expect(page).to have_xpath "//span[@class='expiration-time-room text-green']"
        expect(page).to_not have_content "This Auction has FINISHED"
        expect(page).to_not have_xpath "//span[@class='expiration-time-room text-green hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room.expires_at)
      end
    end

    context "and we reach only 1 minute remaining" do
      scenario "the countdown should change from green to red and start blinking" do
        room = create :room, expires_at: 63.seconds.from_now

        visit room_path(room)

        expect(page).to have_xpath "//span[@class='expiration-time-room text-green']"
        expect(page).to have_xpath "//span[@class='expiration-time-room text-red blinking']"
        expect(page).to have_content "Remaining Time: "
        expect(page).to_not have_content "This Auction has FINISHED"
        expect(page).to_not have_xpath "//span[@class='expiration-time-room text-green']"
        expect(page).to_not have_xpath "//span[@class='expiration-time-room text-green hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room.expires_at)
      end
    end

    context "and we reach 0 seconds remaining" do
      scenario "the countdown should change from red blinking to FINISHED message" do
        room = create :room, expires_at: 3.seconds.from_now

        visit room_path(room)

        expect(page).to have_xpath "//span[@class='expiration-time-room text-red blinking']"
        expect(page).to have_xpath "//span[@class='expiration-time-room text-blue' and text()='FINISHED']"
        expect(page).to have_content "This Auction has FINISHED"
        expect(page).to_not have_content "Remaining Time: "
        expect(page).to_not have_xpath "//span[@class='expiration-time-room text-red blinking']"
        expect(page).to_not have_xpath "//span[@class='expiration-time-room text-green hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"
        expect(page).to_not have_content time_in_milliseconds(room.expires_at)
      end
    end
  end

  context "when auction is no longer active", js: true do

    scenario "should show a FINISHED message and not show remaining time" do
      room = create :room, expires_at: 2.seconds.ago

      visit room_path(room)

      expect(page).to have_content "This Auction has FINISHED"
      expect(page).to_not have_content "Remaining Time: "
      expect(page).to_not have_xpath "//span[@class='expiration-time-room text-green hidden' and text()='#{time_in_milliseconds(room.expires_at)}']"      
      expect(page).to_not have_content time_in_milliseconds(room.expires_at)
    end
  end

end
