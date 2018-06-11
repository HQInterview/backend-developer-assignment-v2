require "rails_helper"

RSpec.feature "User#password_reset", type: :feature do

  context "when user email is not in the database" do
    scenario "should not start password reset process" do
      visit new_reset_password_users_path
      click_button "reset_password"

      expect(page).to_not have_content "Instructions have been sent to your email."
      expect(page).to have_content "User does not exist."
    end
  end

  context "when user email is in the database" do
    scenario "should start and finalize password reset process" do
      user = create :user
      user.activate!
      newpass = "newpassword"

      visit new_reset_password_users_path
      fill_in "email", with: user.email
      click_button "reset_password"

      expect(page).to have_content "Instructions have been sent to your email."

      user.reload
      visit edit_password_user_path user.reset_password_token
      fill_in "user_password",              with: newpass
      fill_in "user_password_confirmation", with: newpass
      click_button "submit_user"

      expect(page).to have_content "Password was successfully updated."

      click_link "Login"
      fill_in "email",    with: user.email
      fill_in "password", with: newpass
      click_button "login_user"

      expect(page).to have_content "Login successfull."
      user.reload
      expect(user.logged_in?).to be true
    end
  end

end
