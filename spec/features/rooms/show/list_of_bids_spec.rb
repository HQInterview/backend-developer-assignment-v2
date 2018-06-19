# coding: utf-8
require "rails_helper"

include RoomsHelper

RSpec.feature "rooms#show", type: :feature do

  context "when there no bid for the auction" do
    scenario "should show a message and not show a table" do
      room = create :room

      visit room_path(room)

      expect(page).to have_content "Nobody posted bids for this Room"
      expect(page).to_not have_content "User"
      expect(page).to_not have_content "Posted At"
      expect(page).to_not have_content "Rejection Cause"
      expect(page).to_not have_content "Status"
    end
  end

  context "when there are bids for the auction" do
    scenario "should show a table with bids and not show a message" do
      room = create :room
      user = create :user
      rejected_bid = create :bid, room: room, user: user, accepted: false, rejection_cause: "invalid bid"
      accepted_bid = create :bid, room: room, user: user, accepted: true

      visit room_path(room)

      within "#bids_table" do
        within "#bid_#{rejected_bid.id}" do
          expect(page).to have_content rejected_bid.id
          expect(page).to have_content user.email
          expect(page).to have_content format_time(rejected_bid.created_at)
          expect(page).to have_content "invalid bid"
          expect(page).to have_xpath "//span[@class='text-red' and text()='REJECTED']"
          expect(page).to have_content "#{rejected_bid.amount} ฿"
        end

        within "#bid_#{accepted_bid.id}" do
          expect(page).to have_content accepted_bid.id
          expect(page).to have_content user.email
          expect(page).to have_content format_time(accepted_bid.created_at)
          expect(page).to_not have_content "invalid bid"
          expect(page).to have_xpath "//span[@class='text-green' and text()='ACCEPTED']"
          expect(page).to have_content "#{accepted_bid.amount} ฿"
        end
      end
      expect(page).to_not have_content "Nobody posted bids for this Room"
    end
  end

  scenario "should paginate the table with bids" do
    room = create :room
    user = create :user, email: "user@email.com"
    bid_4 = create :bid, room: room, user: user
    bid_3 = create :bid, room: room, user: user
    bid_2 = create :bid, room: room, user: user
    bid_1 = create :bid, room: room, user: user
    stub_const("Bid::BIDS_PER_PAGE", 2)

    visit room_path(room)

    within "#bids_table" do
      expect(page).to have_selector "#bid_#{bid_1.id}"
      expect(page).to have_selector "#bid_#{bid_2.id}"
      expect(page).to_not have_selector "#bid_#{bid_3.id}"
      expect(page).to_not have_selector "#bid_#{bid_4.id}"
    end

    visit room_path(room, page: 2)
      expect(page).to have_selector "#bid_#{bid_3.id}"
      expect(page).to have_selector "#bid_#{bid_4.id}"
      expect(page).to_not have_selector "#bid_#{bid_1.id}"
      expect(page).to_not have_selector "#bid_#{bid_2.id}"
    within "#bids_table" do
    end
  end
end
