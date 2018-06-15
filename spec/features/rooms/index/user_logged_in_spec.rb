require "rails_helper"

RSpec.feature "rooms#index", type: :feature do

  context "when user is logged in" do
    scenario "should show a list of active rooms" do
      login_as_user
      room = create :room
      visit root_path

      within "#rooms_table" do
        within "#room_#{room.id}" do
          expect(page).to have_link room.name, href: room_path(room)
        end
      end
    end
  end

  context "when user is logged out" do
    scenario "should show a list of active rooms" do
      room = create :room
      visit root_path

      within "#rooms_table" do
        within "#room_#{room.id}" do
          expect(page).to have_link room.name, href: room_path(room)
        end
      end
    end
  end

end
