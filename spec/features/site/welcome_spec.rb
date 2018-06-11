require "rails_helper"

RSpec.feature "Site#welome", type: :feature, js: true do
  scenario "should show the Welcome Page" do
    visit root_path
    expect(page).to have_title "Auctions - Welcome Page"
    expect(page).to have_content "Welcome to Hotels Rooms Auctions"
  end
end
