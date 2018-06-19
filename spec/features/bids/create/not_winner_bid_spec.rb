# coding: utf-8
require "rails_helper"

include RoomsHelper

RSpec.feature "bids#create", type: :feature do

  scenario "when the bid is not a new winner should post a REJECTED bid" do
    room = create :room
    user = create :user
    login_as_user user
    expect(Bid.count).to be 0

    visit room_path(room)
    within ".form-inline" do
      fill_in "bid_amount", with: (room.minimal_allowed_bid - 1).to_s
      click_button "submit_bid"
    end

    expect(page).to have_content "Bid posted with status REJECTED"
    expect(page).to_not have_content "Bid posted with status ACCEPTED"
    expect(Bid.count).to be 1
    bid = Bid.last
    within "#bids_table" do
      within "#bid_#{bid.id}" do
        expect(page).to have_content bid.id
        expect(page).to have_content user.email
        expect(page).to have_content format_time(bid.created_at)
        expect(page).to have_content "Bid is not >= #{room.minimal_allowed_bid} ฿"
        expect(page).to have_xpath "//span[@class='text-red' and text()='REJECTED']"
        expect(page).to have_content "#{bid.amount} ฿"
      end
    end
  end

end
