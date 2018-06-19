require "rails_helper"

RSpec.feature "User#register", type: :feature do

  context "when values are empty" do
    scenario "should not work" do
      current_users = User.count
      visit register_path
      click_button "submit_user"

      expect(page).to_not have_content "Registration successfull. Check your email for activation instructions."
      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
      expect(User.count).to be current_users
    end
  end

  context "when values are not correct" do
    scenario "should not work" do
      current_users = User.count
      visit register_path
      fill_in "user_email",    with: "wrong.email"
      fill_in "user_password", with: "12"
      click_button "submit_user"

      expect(page).to_not have_content "Registration successfull. Check your email for activation instructions."
      expect(page).to have_content "Email is invalid"
      expect(page).to have_content "Password is too short (minimum is 8 characters)"
      expect(page).to have_content "Password confirmation should match the password"
      expect(User.count).to be current_users
    end
  end

  context "when values are correct" do
    scenario "should work and register a new user" do
      current_users = User.count
      email = "valid.email@domain.com"
      password = "password"
      visit register_path
      fill_in "user_email",                 with: email
      fill_in "user_password",              with: password
      fill_in "user_password_confirmation", with: password
      click_button "submit_user"

      expect(page).to have_content "Registration successfull. Check your email for activation instructions."
      expect(User.count).to be current_users + 1
      user = User.last
      expect(user.email).to eq email
    end
  end

end
