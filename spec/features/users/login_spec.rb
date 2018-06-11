require "rails_helper"

RSpec.feature "User#login", type: :feature do

  context "when user doesn't exist" do
    scenario "should not work" do
      visit login_path
      click_button "login_user"

      expect(page).to have_content "Login Failed!"
    end
  end

  context "when user is not active yet" do
    scenario "should not work" do
      user = create :user, password: "password"
      expect(user.logged_in?).to be false

      visit login_path
      fill_in "email",    with: user.email
      fill_in "password", with: "password"
      click_button "login_user"

      user.reload
      expect(page).to have_content "Login Failed!"
      expect(user.logged_in?).to be false
    end
  end

  context "when user details are not correct" do
    scenario "should not work" do
      user = create :user, password: "password"
      user.activate!
      expect(user.logged_in?).to be false

      visit login_path
      fill_in "email",    with: user.email
      fill_in "password", with: "other"
      click_button "login_user"

      user.reload
      expect(page).to have_content "Login Failed!"
      expect(user.logged_in?).to be false
    end
  end

  context "when user details are correct" do
    scenario "should work and login the user" do
      user = create :user, password: "password"
      user.activate!
      expect(user.logged_in?).to be false

      visit login_path
      fill_in "email",    with: user.email
      fill_in "password", with: "password"
      click_button "login_user"

      user.reload
      expect(page).to have_content "Login successfull."
      expect(user.logged_in?).to be true
    end
  end
end
