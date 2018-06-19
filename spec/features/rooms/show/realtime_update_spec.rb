require "rails_helper"

include RoomsHelper

RSpec.feature "rooms#show", type: :feature do

  context "when somebody post a new bid", js: true do
    scenario "the list of bids should refresh automatically" do
      room = create :room, expires_at: 50.seconds.from_now
      user = create :user
      bid_1 = create :bid, user: user, room: room
      expect(Bid.count).to be 1

      login_as_user user
      visit room_path(room)
      expect(page).to have_xpath "//span[@class='expiration-time-room text-red blinking']"
      within "#bids_table" do
        within "#bid_#{bid_1.id}" do
          expect(page).to have_content bid_1.id
        end
      end
      expect(page).to_not have_selector "#bid_#{bid_1.id + 1}"

      bid_2 = create :bid, user: user, room: room, amount: room.minimal_allowed_bid
      room.set_new_winner! bid_2, user
      within "#bids_table" do
        within "#bid_#{bid_2.id}" do
          expect(page).to have_content bid_2.id
        end
      end
      expect(page).to have_xpath "//span[@class='expiration-time-room text-green']"
      expect(page).to_not have_xpath "//span[@class='expiration-time-room text-red blinking']"
      expect(Bid.count).to be 2

    end
  end

end
