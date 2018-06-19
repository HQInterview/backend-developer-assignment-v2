require "rails_helper"

RSpec.feature "rooms#show", type: :feature do

  scenario "should show the correct information" do
    room = create :room

    visit room_path(room)

    expect(page).to have_title "Auctions - #{room.name}"
    expect(page).to have_content room.name
  end

end
