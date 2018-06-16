require "rails_helper"

RSpec.feature "rooms#index", type: :feature do

  context "when auction is active" do
    scenario "should show the form to post bids" do
      room = create :room
      visit room_path(room)
      expect(page).to have_content "Place a Bid"
      expect(page).to have_xpath "//form[@class='form-inline']"
      expect(page).to have_xpath "//input[@id='bid_amount']"
    end
  end

  context "when auction is not active (finished)" do
    scenario "should not show the form to post bids" do
      room = create :room, expires_at: 1.second.ago
      visit room_path(room)
      expect(page).to have_content room.name
      expect(page).to_not have_content "Place a Bid"
      expect(page).to_not have_xpath "//form[@class='form-inline']"
      expect(page).to_not have_xpath "//input[@id='bid_amount']"
    end
  end

  context "when the countdown reach zero", js: true do
    scenario "the bids form should hide with Javascript" do
      room = create :room, expires_at: 3.seconds.from_now
      visit room_path(room)
      expect(page).to have_content "Place a Bid"
      expect(page).to have_xpath "//form[@class='form-inline']"
      expect(page).to have_xpath "//input[@id='bid_amount']"
      expect(page).to have_content "This Auction has FINISHED"
      expect(page).to_not have_content "Place a Bid"
      expect(page).to_not have_xpath "//form[@class='form-inline']"
      expect(page).to_not have_xpath "//input[@id='bid_amount']"
    end
  end

end
