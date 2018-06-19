require "rails_helper"

RSpec.feature "bids#create", type: :feature do

  scenario "when the room auction has been already deleted should redirect to rooms_path and not create post the bid" do
    room = create :room
    login_as_user
    expect(Bid.count).to be 0

    visit room_path(room)
    room.destroy
    within ".form-inline" do
      fill_in "bid_amount", with: room.minimal_allowed_bid.to_s
      click_button "submit_bid"
    end

    expect(page).to have_content "Bid cannot be posted cause the room acution doesn't exist"
    expect(page).to_not have_content "Bid posted with status"
    expect(Bid.count).to be 0
  end

end
