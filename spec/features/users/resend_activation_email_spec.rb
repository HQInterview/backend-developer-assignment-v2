require "rails_helper"

RSpec.feature "User#resend_activation_email", type: :feature do

  context "when user email is not in the database" do
    scenario "should not resend the activation email" do
      user = create :user, activation_state: nil
      old_activation_code_expires_at = user.activation_code_expires_at

      visit new_act_email_users_path
      fill_in "email", with: "non.existing@user.com"
      click_button "resend_activation"

      expect(page).to have_content "User does not exist."
      user.reload
      expect(user.activation_code_expires_at).to eq old_activation_code_expires_at
    end
  end

  context "when user is already active" do
    scenario "should not resend the activation email" do
      user = create :user
      user.activate!
      user.reload
      old_activation_code_expires_at = user.activation_code_expires_at

      visit new_act_email_users_path
      fill_in "email", with: user.email
      click_button "resend_activation"

      expect(page).to have_content "User is already Active. No need to resend activation email."
      expect(user.activation_code_expires_at).to eq old_activation_code_expires_at
    end
  end

  context "when user exists and it's not active yet" do
    scenario "should resend the activation email" do
      user = create :user, activation_state: nil, activation_code_expires_at: 1.year.ago

      visit new_act_email_users_path
      fill_in "email", with: user.email
      click_button "resend_activation"

      expect(page).to have_content "Activation email resend. Check your email for instructions."
      login_as_user user
      user.reload
      expect(user.logged_in?).to be true
    end
  end

end
