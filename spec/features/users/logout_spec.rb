require "rails_helper"

RSpec.feature "User#logout", type: :feature do
  scenario "should logout correctly" do
    user = create :user, password: "password"
    user.activate!
    user.reload
    expect(user.logged_in?).to be false

    visit root_path
    click_link "login"
    fill_in "email",    with: user.email
    fill_in "password", with: "password"
    click_button "login_user"

    expect(page).to have_content "Login successfull."
    user.reload
    expect(user.logged_in?).to be true

    click_link "logout"

    expect(page).to have_content "Logged out!"
    user.reload
    expect(user.logged_in?).to be false
  end
end
