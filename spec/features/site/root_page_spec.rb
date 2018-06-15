require "rails_helper"

RSpec.feature "Root Page", type: :feature do
  scenario "should update the title and show a welcome message" do
    visit root_path

    expect(page).to have_title "Auctions - Welcome to Hotels Rooms Auctions"
    expect(page).to have_content "Welcome to Hotels Rooms Auctions"
  end
end
