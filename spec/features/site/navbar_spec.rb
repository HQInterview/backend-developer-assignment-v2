require "rails_helper"

RSpec.feature "Navigation Bar", type: :feature do

  scenario "should have a link to root_path" do
    visit root_path
    expect(page).to have_link "Auctions", href: root_path
  end

  context "when user is logged out" do
    scenario "should have correct links" do
      visit root_path

      within "#navbarUser" do
        expect(page).to_not have_content "logged as:"
        expect(page).to_not have_link "Logout", href: logout_path
        expect(page).to have_link "Login", href: login_path
        expect(page).to have_link "Register", href: register_path
      end
    end
  end

  context "when user is logged in" do
    scenario "should have correct links" do
      user = create :user
      login_as_user user

      within ".navbar-collapse" do
        expect(page).to have_content "logged as:"
        expect(page).to have_link "Logout", href: logout_path
        expect(page).to_not have_link "Login", href: login_path
        expect(page).to_not have_link "Register", href: register_path
      end
    end
  end
end
