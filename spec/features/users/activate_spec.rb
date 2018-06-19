require "rails_helper"

RSpec.feature "User#activate", type: :feature do

  context "when user is not active" do
    scenario "should work" do
      user = create :user, activation_state: nil
      expect(user).to_not be_active

      visit activate_user_path id: user.activation_code

      expect(page).to have_content "User was successfully activated."
      user.reload
      expect(user).to be_active
    end
  end

  context "when user is already active" do
    scenario "should not raise error" do
      user = create :user, activation_state: nil
      old_activation_code = user.activation_code
      user.activate!
      expect(user).to be_active

      visit activate_user_path id: old_activation_code

      expect(page).to have_content "Operation failed!"
      user.reload
      expect(user).to be_active
    end
  end
end
