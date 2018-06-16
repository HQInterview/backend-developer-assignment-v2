require "rails_helper"

RSpec.feature "bids#create", type: :feature do

  context "when user is logged in" do
    scenario "should allow to post bids" do
      room = create :room
      login_as_user

      visit room_path(room)
      within ".form-inline" do
        fill_in "bid_amount", with: room.minimal_allowed_bid.to_s
        click_button "submit_bid"
      end

      expect(page).to have_content "Bid posted with status ACCEPTED"
      expect(page).to_not have_content "Operation failed! Please log in first."
    end
  end

  context "when user is logged out" do
    scenario "should not allow to post bids" do
      room = create :room

      visit room_path(room)
      within ".form-inline" do
        fill_in "bid_amount", with: room.minimal_allowed_bid.to_s
        click_button "submit_bid"
      end

      expect(page).to have_content "Operation failed! Please log in first."
      expect(page).to_not have_content "Bid posted with status ACCEPTED"
    end
  end

end
