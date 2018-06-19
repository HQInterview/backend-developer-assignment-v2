# coding: utf-8
require "rails_helper"

RSpec.feature "rooms#show", type: :feature do

  context "when nobody posted any bid" do
    scenario "should show the minimal bid information" do
      room = create :room

      visit room_path(room)

      expect(page).to have_content "The minimal bid is #{room.minimal_bid} ฿"
      expect(page).to_not have_content "The highest bid is"
      expect(page).to_not have_content "posted by"
    end
  end

end
