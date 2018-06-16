# coding: utf-8
require "rails_helper"

include RoomsHelper

RSpec.feature "bids#create", type: :feature do

  scenario "when the bid is a new winner and there is no previous winner bid should post a ACCEPTED bid" do
    room = create :room
    user = create :user
    login_as_user user
    expect(Bid.count).to be 0

    visit room_path(room)
    expect(page).to have_content "The minimal bid is "
    expect(page).to_not have_content "posted by "
    within ".form-inline" do
      fill_in "bid_amount", with: room.minimal_allowed_bid.to_s
      click_button "submit_bid"
    end

    expect(page).to have_content "Bid posted with status ACCEPTED"
    expect(page).to_not have_content "Bid posted with status REJECTED"
    expect(Bid.count).to be 1
    bid = Bid.last
    within "#bids_table" do
      within "#bid_#{bid.id}" do
        expect(page).to have_content bid.id
        expect(page).to have_content user.email
        expect(page).to have_content format_time(bid.created_at)
        expect(page).to_not have_content "Bid is not >= #{room.minimal_allowed_bid} ฿"
        expect(page).to have_xpath "//span[@class='text-green' and text()='ACCEPTED']"
        expect(page).to have_content "#{bid.amount} ฿"
      end
    end
    expect(page).to have_content "The highest bid is #{bid.amount} ฿"
    expect(page).to_not have_content "The minimal bid is "
    expect(page).to have_content "posted by #{user.email}"
  end

  scenario "when the bid is a new winner and there is a previous winner bid should post a ACCEPTED bid" do
    room = create :room, winner_bid: 2000, winner_user_email: "winner@user.email"
    user = create :user
    login_as_user user
    expect(Bid.count).to be 0

    visit room_path(room)
    expect(page).to have_content "The highest bid is 2000 ฿"
    expect(page).to_not have_content "The minimal bid is "
    expect(page).to have_content "posted by winner@user.email"
    within ".form-inline" do
      fill_in "bid_amount", with: room.minimal_allowed_bid.to_s
      click_button "submit_bid"
    end

    expect(page).to have_content "Bid posted with status ACCEPTED"
    expect(page).to_not have_content "Bid posted with status REJECTED"
    expect(Bid.count).to be 1
    bid = Bid.last
    within "#bids_table" do
      within "#bid_#{bid.id}" do
        expect(page).to have_content bid.id
        expect(page).to have_content user.email
        expect(page).to have_content format_time(bid.created_at)
        expect(page).to_not have_content "Bid is not >= #{room.minimal_allowed_bid} ฿"
        expect(page).to have_xpath "//span[@class='text-green' and text()='ACCEPTED']"
        expect(page).to have_content "#{bid.amount} ฿"
      end
    end
    expect(page).to have_content "The highest bid is #{bid.amount} ฿"
    expect(page).to_not have_content "The minimal bid is "
    expect(page).to_not have_content "The highest bid is 2000 ฿"
    expect(page).to have_content "posted by #{user.email}"
    expect(page).to_not have_content "posted by winner@user.email"
  end

end
