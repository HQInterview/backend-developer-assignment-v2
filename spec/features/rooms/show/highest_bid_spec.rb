# coding: utf-8
require "rails_helper"

RSpec.feature "rooms#show", type: :feature do

  context "when somebody posted any bid" do
    scenario "should show the hightest bid information" do
      room = create :room, winner_bid: 2000, winner_user_email: "winner@user.email"

      visit room_path(room)

      expect(page).to have_content "The highest bid is #{room.winner_bid} ฿"
      expect(page).to have_content "posted by winner@user.email"
      expect(page).to_not have_content "The minimal bid is"
    end
  end

end
