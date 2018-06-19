require "rails_helper"

RSpec.feature "rooms#index", type: :feature do

  context "when user is logged in" do
    scenario "should show the room information" do
      login_as_user
      room = create :room
      visit room_path(room)
      expect(page).to have_content room.name
    end
  end

  context "when user is logged out" do
    scenario "should show a list of active rooms" do
      room = create :room
      visit room_path(room)
      expect(page).to have_content room.name
    end
  end

end
